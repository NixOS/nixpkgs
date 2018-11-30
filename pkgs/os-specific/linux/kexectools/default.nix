{ stdenv, buildPackages, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "kexec-tools-${version}";
  version = "2.0.17";

  src = fetchurl {
    urls = [
      "mirror://kernel/linux/utils/kernel/kexec/${name}.tar.xz"
      "http://horms.net/projects/kexec/kexec-tools/${name}.tar.xz"
    ];
    sha256 = "1ac20jws8iys9w6dpn4q3hihyx73zkabdwv3gcb779cxfrmq2k2h";
  };

  hardeningDisable = [ "format" "pic" "relro" ];

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
