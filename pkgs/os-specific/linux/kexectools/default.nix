{ stdenv, buildPackages, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "kexec-tools-${version}";
  version = "2.0.19";

  src = fetchurl {
    urls = [
      "mirror://kernel/linux/utils/kernel/kexec/${name}.tar.xz"
      "http://horms.net/projects/kexec/kexec-tools/${name}.tar.xz"
    ];
    sha256 = "03jyi4c47ywclycf3a253xpqs7p6ys8inz9q66b8m3xc6nrh307d";
  };

  hardeningDisable = [ "format" "pic" "relro" "pie" ];

  configureFlags = [ "BUILD_CC=${buildPackages.stdenv.cc.targetPrefix}cc" ];
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  buildInputs = [ zlib ];

  meta = with stdenv.lib; {
    homepage = http://horms.net/projects/kexec/kexec-tools;
    description = "Tools related to the kexec Linux feature";
    platforms = platforms.linux;
    badPlatforms = [
      "riscv64-linux" "riscv32-linux"
      "sparc-linux" "sparc64-linux"
    ];
    license = licenses.gpl2;
  };
}
