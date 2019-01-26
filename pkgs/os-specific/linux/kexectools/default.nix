{ stdenv, buildPackages, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "kexec-tools-${version}";
  version = "2.0.18";

  src = fetchurl {
    urls = [
      "mirror://kernel/linux/utils/kernel/kexec/${name}.tar.xz"
      "http://horms.net/projects/kexec/kexec-tools/${name}.tar.xz"
    ];
    sha256 = "0f5jnb0470nmxyl1cz2687hqjr8cwqniqc1ycq9bazlp85rz087h";
  };

  hardeningDisable = [ "format" "pic" "relro" "pie" ];

  configureFlags = [ "BUILD_CC=${buildPackages.stdenv.cc.targetPrefix}cc" ];
  nativeBuildInputs = [ buildPackages.stdenv.cc ];
  buildInputs = [ zlib ];

  meta = with stdenv.lib; {
    homepage = http://horms.net/projects/kexec/kexec-tools;
    description = "Tools related to the kexec Linux feature";
    platforms = platforms.linux;
    license = licenses.gpl2;
    badPlatforms = platforms.riscv;
  };
}
