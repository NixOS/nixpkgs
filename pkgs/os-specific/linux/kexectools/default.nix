{ stdenv, buildPackages, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "kexec-tools-${version}";
  version = "2.0.16";

  src = fetchurl {
    urls = [
      "mirror://kernel/linux/utils/kernel/kexec/${name}.tar.xz"
      "http://horms.net/projects/kexec/kexec-tools/${name}.tar.xz"
    ];
    sha256 = "043hasx5b9zk7r7dzx24z5wybg74dpmh0nyns6nrnb3mmm8k642v";
  };

  hardeningDisable = [ "format" "pic" "relro" ];

  configureFlags = [ "BUILD_CC=${buildPackages.stdenv.cc.targetPrefix}cc" ];
  nativeBuildInputs = [ buildPackages.stdenv.cc ];
  buildInputs = [ zlib ];

  meta = with stdenv.lib; {
    homepage = http://horms.net/projects/kexec/kexec-tools;
    description = "Tools related to the kexec Linux feature";
    platforms = platforms.linux;
  };
}
