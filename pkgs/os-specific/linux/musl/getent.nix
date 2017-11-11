{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "musl-getent";
  src = fetchurl {
    url = "https://raw.githubusercontent.com/alpinelinux/aports/89a718d88ec7466e721f3bbe9ede5ffe58061d78/main/musl/getent.c";
    sha256 = "0b4jqnsmv1hjgcz7db3vd61k682aphl59c3yhwya2q7mkc6g48xk";
  };

  unpackPhase = ":";

  buildPhase = ''$CC $src -o getent'';
  installPhase = ''
    mkdir -p $out/bin
    cp getent $out/bin/
  '';
}

