{ lib, stdenv, buildPackages, fetchurl, fetchpatch, zlib }:

stdenv.mkDerivation rec {
  pname = "kexec-tools";
  version = "2.0.26";

  src = fetchurl {
    urls = [
      "mirror://kernel/linux/utils/kernel/kexec/${pname}-${version}.tar.xz"
      "http://horms.net/projects/kexec/kexec-tools/${pname}-${version}.tar.xz"
    ];
    sha256 = "sha256-f+NqBkEBzVxRXkGyvjk9zjyoitzlnW7maOCvfAxFcM0=";
  };

  patches = [
    # Use ELFv2 ABI on ppc64be
    (fetchpatch {
      url = "https://raw.githubusercontent.com/void-linux/void-packages/6c1192cbf166698932030c2e3de71db1885a572d/srcpkgs/kexec-tools/patches/ppc64-elfv2.patch";
      sha256 = "19wzfwb0azm932v0vhywv4221818qmlmvdfwpvvpfyw4hjsc2s1l";
    })
  ];

  hardeningDisable = [ "format" "pic" "relro" "pie" ];

  # Prevent kexec-tools from using uname to detect target, which is wrong in
  # cases like compiling for aarch32 on aarch64
  configurePlatforms = [ "build" "host" ];
  configureFlags = [ "BUILD_CC=${buildPackages.stdenv.cc.targetPrefix}cc" ];
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  buildInputs = [ zlib ];

  meta = with lib; {
    homepage = "http://horms.net/projects/kexec/kexec-tools";
    description = "Tools related to the kexec Linux feature";
    platforms = platforms.linux;
    badPlatforms = [
      "microblaze-linux" "microblazeel-linux"
      "riscv64-linux" "riscv32-linux"
      "sparc-linux" "sparc64-linux"
    ];
    license = licenses.gpl2;
  };
}
