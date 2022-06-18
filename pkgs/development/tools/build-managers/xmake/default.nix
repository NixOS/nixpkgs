{ lib, stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "xmake";
  version = "2.6.7";

  src = fetchFromGitHub {
    owner = "xmake-io";
    repo = "xmake";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-e6V/RM07T6TCCxdIL47M9P7KiNA6v+mMOcSBZkSp3YQ=";
  };

  enableParallelBuilding = true;

  installFlags = [ "prefix=${placeholder "out"}" ];

  meta = with lib; {
    description = "A cross-platform build utility based on Lua";
    homepage    = "https://xmake.io/";
    license     = licenses.asl20;
    platforms   = platforms.all;
    maintainers = with maintainers; [ hyqhyq3 ];
  };
}
