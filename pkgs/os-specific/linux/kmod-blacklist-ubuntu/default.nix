{ stdenv, fetchurl }:
let
  version = "3ubuntu1"; # Saucy
in
stdenv.mkDerivation {
  name = "kmod-blacklist-${version}";

  src = fetchurl {
    url = "http://archive.ubuntu.com/ubuntu/pool/main/k/kmod/kmod_9-${version}.debian.tar.gz";
    sha256 = "0h6h0zw2490iqj9xa2sz4309jyfmcc50jdvkhxa1nw90npxglp67";
  };

  installPhase = ''
    mkdir "$out"
    for f in modprobe.d/*.conf; do
      echo "''\n''\n## file: "`basename "$f"`"''\n''\n" >> "$out"/modprobe.conf
      cat "$f" >> "$out"/modprobe.conf
    done
  '';

  #TODO: iwlwifi.conf has some strange references

  meta = {
    homepage = http://packages.ubuntu.com/source/saucy/kmod;
    description = "Linux kernel module blacklists from Ubuntu";
  };
}
