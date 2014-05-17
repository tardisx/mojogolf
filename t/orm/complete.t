
use Test::More;

use strict;

# test ORM modules
use_ok('MojoGolf::DB::User');
use_ok('MojoGolf::DB::Language');
use_ok('MojoGolf::DB::Challenge');
use_ok('MojoGolf::DB::ChallengeData');
use_ok('MojoGolf::DB::ChallengeEntry');

# create a user
my $user = MojoGolf::DB::User->new(username => "testuser_$$")->save();
basic_db_check($user, 'user');

# create a language for them to use (perl)
my $plang = MojoGolf::DB::Language->new(name => "perl_$$", compile => 'perl!-cw!SRC', run => 'perl!SRC')->save();
basic_db_check($plang, 'perl language');

# and another for java
my $jlang = MojoGolf::DB::Language->new(name => "java_$$",
                                        compile => 'javac!SRC',
                                        run => 'java!SRC')->save();
basic_db_check($jlang, 'java language');

$jlang->boilerplate(qq|
import java.io.*;

public class MojoGolf {
  public static void main(String[] args) throws IOException {
    BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
    String s;
    while ((s = in.readLine()) != null && s.length() != 0)
      System.out.println(s);
  }
}
|);
$jlang->save();

# create a challenge for them to enter
my $challenge = MojoGolf::DB::Challenge->new(name => "number_add_$$", descr => 'add numbers together')->save();
basic_db_check($challenge, 'challenge');

# create challenge data for this challenge
my $c_data = MojoGolf::DB::ChallengeData->new(challenge_id => $challenge->id,
                                              input => "1\n2\n3\n",
                                              output => "6\n",
                                              hidden => 0)->save();
basic_db_check($c_data, 'challenge data');

# create an entry for this user
my $entry = MojoGolf::DB::ChallengeEntry->new(challenge_id => $challenge->id,
                                              user_id      => $user->id,
                                              language_id  => $plang->id,
                                              code => 'whale(<>){chomp;$tot+=$_}END{say $tot}',
                                             )->save();

ok(! $entry->compile, 'entry correctly fails compilation');
ok($entry->compiler_error, 'has a compiler error');
ok($entry->compiler_error =~ m/syntax error at/ms, 'has the right error');

# change it so it works
$entry->code('while(<>){chomp;$tot+=$_}END{say $tot}');
$entry->save;

# should now compile
ok($entry->compile, 'entry compiles now');
ok(! $entry->compiler_error, 'has no compiler error now');

# try java, if we have it
SKIP: {
  skip 'no java available', 3 unless (`which javac` && `which java`);
  my $jentry = MojoGolf::DB::ChallengeEntry->new(challenge_id => $challenge->id,
                                                 user_id      => $user->id,
                                                 language_id  => $jlang->id,
                                                 code         => 'XXX',
                                                )->save();


  basic_db_check($jentry, 'java entry');
  ok($jentry->delete,  'delete java entry');
}

# delete ALL the things
ok($entry->delete,     'delete entry');
ok($c_data->delete,    'delete challenge data');
ok($challenge->delete, 'delete challenge');
ok($plang->delete,     'delete language');
ok($jlang->delete,     'delete language');
ok($user->delete,      'delete user');

done_testing();


sub basic_db_check {
    my $obj = shift;
    my $name = shift;

    ok($obj, "$name exists");
    ok($obj->id, "$name has an id");
    cmp_ok($obj->id, '>', 0, "$name has a positive id");

}
