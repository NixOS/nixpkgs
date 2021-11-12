{ lib, stdenv, buildPackages, fetchurl, zlib, fetchpatch }:

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

  # Prevent kexec-tools from using uname to detect target, which is wrong in
  # cases like compiling for aarch32 on aarch64
  configurePlatforms = [ "build" "host" ];
  configureFlags = [ "BUILD_CC=${buildPackages.stdenv.cc.targetPrefix}cc" ];
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  buildInputs = [ zlib ];

  patches = [
    # fix build on i686
    # See: https://src.fedoraproject.org/rpms/kexec-tools/c/cb1e5463b5298b064e9b6c86ad6fe3505fec9298
    (fetchpatch {
      name = "kexec-tools-2.0.20-fix-broken-multiboot2-buliding-for-i386.patch";
      url = "https://src.fedoraproject.org/rpms/kexec-tools/raw/cb1e5463b5298b064e9b6c86ad6fe3505fec9298/f/kexec-tools-2.0.20-fix-broken-multiboot2-buliding-for-i386.patch";
      sha256 = "1kzmcsbhwfdgxlc5s88ir0n494phww1j16yk0z42x09qlkxxkg0l";
    })

    (fetchpatch {
      # upstream build fix against -fno-common compilers like >=gcc-10
      name = "fno-common.patch";
      url = "https://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git/patch/?id=cc087b11462af9f971a2c090d07e8d780a867b50";
      sha256 = "043hcsy6m14h64p6b9w25c7a3y0f487322dj81l6mbm6sws6s9lv";
    })
  ];

  meta = with lib; {
    homepage = "http://horms.net/projects/kexec/kexec-tools";
    description = "Tools related to the kexec Linux feature";
    platforms = platforms.linux;
    badPlatforms = [
      "riscv64-linux" "riscv32-linux"
      "sparc-linux" "sparc64-linux"
    ];
    license = licenses.gpl2;
  };
}
