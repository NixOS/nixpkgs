{ lib, stdenv, fetchgit
# optional list of extra waf tools, e.g. `[ "doxygen" "pytest" ]`

}:
let
in
stdenv.mkDerivation rec {
  pname = "xmake";
  version = "2.6.7";

  src = fetchgit {
    url = "https://github.com/xmake-io/xmake";
    rev = "v${version}";
    sha256 = "sha256-e6V/RM07T6TCCxdIL47M9P7KiNA6v+mMOcSBZkSp3YQ=";
  };

  enableParallelBuilding = true;

  installPhase = ''
    make install prefix=$out
  '';

  meta = with lib; {
    description = "A cross-platform build utility based on Lua";
    homepage    = "https://xmake.io/";
    license     = licenses.asl20;
    platforms   = platforms.all;
    maintainers = with maintainers; [ hyqhyq3 ];
  };
}
