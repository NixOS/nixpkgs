{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "bakelite";
  version = "unstable-2022-02-12";

  src = fetchFromGitHub {
    owner = "richfelker";
    repo = pname;
    rev = "373901734d114e42aa385e6a7843745674e4ca08";
    hash = "sha256-HBnYlUyTkvPTbdsZD02yCq5C7yXOHYK4l4mDRUkcN5I=";
  };

  hardeningEnable = [ "pie" ];
  preBuild = ''
    # pipe2() is only exposed with _GNU_SOURCE
    # Upstream makefile explicitly uses -O3 to improve SHA-3 performance
    makeFlagsArray+=( CFLAGS="-D_GNU_SOURCE -g -O3" )
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bakelite $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/richfelker/bakelite";
    description = "Incremental backup with strong cryptographic confidentality";
    license = licenses.gpl2;
    maintainers = with maintainers; [ mvs ];
    # no support for Darwin (yet: https://github.com/richfelker/bakelite/pull/5)
    platforms = platforms.linux;
  };
}
