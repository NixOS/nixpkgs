{ lib, stdenv, fetchurl, linuxHeaders, perl }:

let
  commonMakeFlags = [
    "prefix=$(out)"
    "SHLIBDIR=$(out)/lib"
  ];
in

stdenv.mkDerivation rec {
  pname = "klibc";
  version = "2.0.7";

  src = fetchurl {
    url = "mirror://kernel/linux/libs/klibc/2.0/klibc-${version}.tar.xz";
    sha256 = "08li3aj9bvzabrih98jdxi3m19h85cp53s8cr7cqad42r8vjdvxb";
  };

  patches = [ ./no-reinstall-kernel-headers.patch ];

  nativeBuildInputs = [ perl ];

  hardeningDisable = [ "format" "stackprotector" ];

  makeFlags = commonMakeFlags ++ [
    "KLIBCARCH=${stdenv.hostPlatform.platform.kernelArch}"
    "KLIBCKERNELSRC=${linuxHeaders}"
  ] # TODO(@Ericson2314): We now can get the ABI from
    # `stdenv.hostPlatform.parsed.abi`, is this still a good idea?
    ++ stdenv.lib.optional (stdenv.hostPlatform.platform.kernelArch == "arm") "CONFIG_AEABI=y"
    ++ stdenv.lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "CROSS_COMPILE=${stdenv.cc.targetPrefix}";

  # Install static binaries as well.
  postInstall = ''
    dir=$out/lib/klibc/bin.static
    mkdir $dir
    cp $(find $(find . -name static) -type f ! -name "*.g" -a ! -name ".*") $dir/

    for file in ${linuxHeaders}/include/*; do
      ln -sv $file $out/lib/klibc/include
    done
  '';

  meta = {
    description = "Minimalistic libc subset for initramfs usage";
    homepage = "https://kernel.org/pub/linux/libs/klibc/";
    maintainers = with lib.maintainers; [ fpletz ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
