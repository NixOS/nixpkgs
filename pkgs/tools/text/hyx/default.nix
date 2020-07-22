{ lib, stdenv, fetchurl }:
let
  # memstream — POSIX memory streams for BSD
  memstream = fetchurl {
    url = "https://piumarta.com/software/memstream/memstream-0.1.tar.gz";
    sha256 = "0kvdb897g7nyviaz72arbqijk2g2wa61cmi3l5yh48rzr49r3a3a";
  };
in
stdenv.mkDerivation rec {
  pname = "hyx";
  version = "2020-06-09";

  src = fetchurl {
    url = "https://yx7.cc/code/hyx/hyx-${lib.replaceStrings [ "-" ] [ "." ] version}.tar.xz";
    sha256 = "1x8dmll93hrnj24kn5knpwj36y6r1v2ygwynpjwrg2hwd4c1a8hi";
  };

  postUnpack = lib.optionalString stdenv.isDarwin ''
    tar --strip=1 -C $sourceRoot -xf ${memstream} --wildcards "memstream-0.1/memstream.[hc]"
  '';

  patches = lib.optional stdenv.isDarwin ./memstream.patch;

  installPhase = ''
    install -vD hyx $out/bin/hyx
  '';

  meta = with lib; {
    description = "minimalistic but powerful Linux console hex editor";
    homepage = "https://yx7.cc/code/";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
    platforms = with platforms; linux ++ darwin;
  };
}
