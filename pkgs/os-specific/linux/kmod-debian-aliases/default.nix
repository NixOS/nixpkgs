{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  pname = "kmod-debian-aliases.conf";
  version = "22-1.1";

  src = fetchurl {
    url = "https://snapshot.debian.org/archive/debian/20160404T220610Z/pool/main/k/kmod/kmod_${version}.debian.tar.xz";
    sha256 = "0daap2n4bvjqcnksaayy6csmdb1px4r02w3xp36bcp6w3lbnqamh";
  };

  installPhase = ''
    patch -i patches/aliases_conf
    cp aliases.conf $out
  '';

  meta = with lib; {
    homepage = "https://packages.debian.org/source/sid/kmod";
    description = "Linux configuration file for modprobe";
    maintainers = with maintainers; [ mathnerd314 ];
    platforms = with platforms; linux;
    license = with licenses; [ gpl2Plus lgpl21Plus ];
  };
}
