{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "module-init-tools-3.2.2";
  src = fetchurl {
    url = ftp://ftp.kernel.org/pub/linux/utils/kernel/module-init-tools/module-init-tools-3.2.2.tar.bz2;
    md5 = "a1ad0a09d3231673f70d631f3f5040e9";
  };
  patches = [./module-dir.patch];
  postInstall = "rm $out/sbin/insmod.static"; # don't need it
}
