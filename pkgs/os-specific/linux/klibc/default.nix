{ lib, stdenv, fetchurl, buildPackages, linuxHeaders, perl, nixosTests }:

let
  commonMakeFlags = [
    "prefix=$(out)"
    "SHLIBDIR=$(out)/lib"
  ];
in

stdenv.mkDerivation rec {
  pname = "klibc";
  version = "2.0.12";

  src = fetchurl {
    url = "mirror://kernel/linux/libs/klibc/2.0/klibc-${version}.tar.xz";
    hash = "sha256-cfgWoNOr46uotGMZrlyhR+eno4QBs/XiYgJfTcCMR10=";
  };

  patches = [ ./no-reinstall-kernel-headers.patch ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ perl ];
  strictDeps = true;

  hardeningDisable = [ "format" "stackprotector" ];

  makeFlags = commonMakeFlags ++ [
    "KLIBCARCH=${if stdenv.hostPlatform.isRiscV64 then "riscv64" else stdenv.hostPlatform.linuxArch}"
    "KLIBCKERNELSRC=${linuxHeaders}"
  ] # TODO(@Ericson2314): We now can get the ABI from
    # `stdenv.hostPlatform.parsed.abi`, is this still a good idea?
    ++ lib.optional (stdenv.hostPlatform.linuxArch == "arm") "CONFIG_AEABI=y"
    ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "CROSS_COMPILE=${stdenv.cc.targetPrefix}";

  # Install static binaries as well.
  postInstall = ''
    dir=$out/lib/klibc/bin.static
    mkdir $dir
    cp $(find $(find . -name static) -type f ! -name "*.g" -a ! -name ".*") $dir/

    for file in ${linuxHeaders}/include/*; do
      ln -sv $file $out/lib/klibc/include
    done
  '';

  passthru.tests = {
    # uses klibc's ipconfig
    inherit (nixosTests) initrd-network-ssh;
  };

  meta = {
    description = "Minimalistic libc subset for initramfs usage";
    homepage = "https://kernel.org/pub/linux/libs/klibc/";
    maintainers = with lib.maintainers; [ fpletz ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
