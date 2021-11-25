{ lib, stdenv, fetchgit, sqlite, pkg-config, perl
, buildllvmsparse ? true
, buildc2xml ? true
, llvm, libxml2
}:

stdenv.mkDerivation rec {
  pname = "smatch";
  version = "20120924";

  src = fetchgit {
    url = "git://repo.or.cz/${pname}.git";
    rev = "23656e3e578b700cbf96d043f039e6341a3ba5b9";
    sha256 = "0r43qi6vryqg450fj73yjwbb7gzcgx64rhrhb3r1m6a252srijiy";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ sqlite perl ]
   ++ lib.optional buildllvmsparse llvm
   ++ lib.optional buildc2xml libxml2;

  preBuild = ''
    sed -i Makefile \
      -e "s|^PREFIX=.*|PREFIX = $out|g"
  '';

  meta = with lib; {
    description = "A semantic analysis tool for C";
    homepage = "http://smatch.sourceforge.net/";
    maintainers = with maintainers; [];
    license = licenses.free; /* OSL, see http://www.opensource.org */
    platforms = platforms.linux;
  };
}
