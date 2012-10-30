{ stdenv, fetchgit, sqlite, pkgconfig, perl
, buildllvmsparse ? true
, buildc2xml ? true
, llvm ? null, libxml2 ? null
}:

assert buildllvmsparse -> llvm != null;
assert buildc2xml -> libxml2 != null;

stdenv.mkDerivation {
  name = "smatch";

  src = fetchgit {
    url = git://repo.or.cz/smatch.git;
    rev = "23656e3e578b700cbf96d043f039e6341a3ba5b9";
    sha256 = "09a44967d4cff026c67062f778e251d0b432af132e9d59a47b7d3167f379adfa";
  };

  buildInputs = [sqlite pkgconfig perl]
   ++ stdenv.lib.optional buildllvmsparse llvm
   ++ stdenv.lib.optional buildc2xml libxml2;

  preBuild =
    '' sed -i Makefile \
           -e "s|^PREFIX=.*|PREFIX = $out|g"
    '';

  meta = {
    description = "A semantic analysis tool for C";
    homepage = "http://smatch.sourceforge.net/";
    license = "free"; /* OSL, see http://www.opensource.org */
  };
}
