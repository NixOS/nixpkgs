{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  name = "kmod-debian-aliases-${version}.conf";
  version = "22-1.1";

  src = fetchurl {
    url = "http://snapshot.debian.org/archive/debian/20160404T220610Z/pool/main/k/kmod/kmod_${version}.debian.tar.xz";
    sha256 = "0daap2n4bvjqcnksaayy6csmdb1px4r02w3xp36bcp6w3lbnqamh";
  };

  installPhase = ''
    patch -i patches/aliases_conf
    cp aliases.conf $out
  '';

  meta = {
    homepage = https://packages.debian.org/source/sid/kmod;
    description = "Linux configuration file for modprobe";
    maintainers = with lib.maintainers; [ mathnerd314 ];
    platforms = with lib.platforms; linux;
  };
}
