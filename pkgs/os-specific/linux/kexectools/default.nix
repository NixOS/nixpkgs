{ stdenv, buildPackages, fetchurl, zlib }:

stdenv.mkDerivation rec {
  pname = "kexec-tools";
  version = "2.0.20";

  src = fetchurl {
    urls = [
      "mirror://kernel/linux/utils/kernel/kexec/${pname}-${version}.tar.xz"
      "http://horms.net/projects/kexec/kexec-tools/${pname}-${version}.tar.xz"
    ];
    sha256 = "1j7qlhxk1rbv9jbj8wd6hb7zl8p2mp29ymrmccgmsi0m0dzhgn6s";
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
