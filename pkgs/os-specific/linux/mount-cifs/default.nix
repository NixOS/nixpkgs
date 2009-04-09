{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "mount.cifs";
  
  src = fetchurl {
    url = http://nixos.org/tarballs/mount_cifs-20090330.c;
    sha256 = "1d9v3qzic3d12vna8g7d1zsl1piwm20f6xhck319rbfkrdg0smnl";
  };
 
  buildCommand = ''
    ensureDir $out/sbin
    gcc -Wall $src -o $out/sbin/mount.cifs
  '';
}
