{ stdenv, fetchgit, sqlite, pkgconfig, perl
, buildllvmsparse ? true
, buildc2xml ? true
, llvm ? null, libxml2 ? null
}:

assert buildllvmsparse -> llvm != null;
assert buildc2xml -> libxml2 != null;

stdenv.mkDerivation {
  name = "smatch-20120924";

  src = fetchgit {
    url = git://repo.or.cz/smatch.git;
    rev = "23656e3e578b700cbf96d043f039e6341a3ba5b9";
    sha256 = "0r43qi6vryqg450fj73yjwbb7gzcgx64rhrhb3r1m6a252srijiy";
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
    license = stdenv.lib.licenses.free; /* OSL, see http://www.opensource.org */
    platforms = stdenv.lib.platforms.linux;
  };
}
