{ stdenv, fetchurl, lib }:
let
  version = "21-1";
in
stdenv.mkDerivation {
  name = "kmod-debian-aliases-${version}.conf";

  src = fetchurl {
    url = "mirror://debian/pool/main/k/kmod/kmod_${version}.debian.tar.xz";
    sha256 = "1abpf8g3yx972by2xpmz6dwwyc1pgh6gjbvrivmrsws69vs0xjsy";
  };

  installPhase = ''
    patch -i patches/aliases_conf
    cp aliases.conf $out
  '';

  meta = {
    homepage = https://packages.debian.org/source/sid/kmod;
    description = "Linux configuration file for modprobe";
    maintainers = with lib.maintainers; [ mathnerd314 ];
  };
}
