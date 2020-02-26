# assumes that there are directories REP and DOC left from tests in 040
use lib 'lib';
use Test;
use Test::Output;
use Pod::To::Cached;
use File::Directory::Tree;

constant REP = 't/tmp/ref';
constant DOC = 't/tmp/doc';
constant COUNT = 3; # number of caches to create
rmtree DOC if DOC.IO ~~ :d;
rmtree REP if REP.IO ~~ :d;

mkdir DOC;
mkdir REP;

diag "Create multiple ({ COUNT }) caches";

my @caches;

for ^COUNT {
    mkdir REP ~ $_;
    lives-ok {
        @caches[$_] = Pod::To::Cached.new( :source( DOC ), :path( REP ~ $_ ), :!verbose)
    }, "created cache no $_";
    lives-ok {
        @caches[$_].update-cache
    }, "update cache no $_";
}

for ^COUNT {
    ok (REP ~ $_ ).IO.d
}

done-testing;
