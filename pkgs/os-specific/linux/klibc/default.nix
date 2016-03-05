{ stdenv, fetchurl, kernelHeaders, kernel, perl }:

let
  version = "2.0.4";

  commonMakeFlags = [
    "prefix=$(out)"
    "SHLIBDIR=$(out)/lib"
  ];
in

stdenv.mkDerivation {
  name = "klibc-${version}-${kernel.version}";

  src = fetchurl {
    url = "mirror://kernel/linux/libs/klibc/2.0/klibc-${version}.tar.xz";
    sha256 = "7f9a0850586def7cf4faeeb75e5d0f66e613674c524f6e77b0f4d93a26c801cb";
  };

  patches = [ ./no-reinstall-kernel-headers.patch ];

  nativeBuildInputs = [ perl ];

  hardeningDisable = [ "format" "stackprotector" ];

  makeFlags = commonMakeFlags ++ [
    "KLIBCARCH=${stdenv.platform.kernelArch}"
    "KLIBCKERNELSRC=${kernelHeaders}"
  ] ++ stdenv.lib.optional (stdenv.platform.kernelArch == "arm") "CONFIG_AEABI=y";

  crossAttrs = {
    makeFlags = commonMakeFlags ++ [
      "KLIBCARCH=${stdenv.cross.platform.kernelArch}"
      "KLIBCKERNELSRC=${kernelHeaders.crossDrv}"
      "CROSS_COMPILE=${stdenv.cross.config}-"
    ] ++ stdenv.lib.optional (stdenv.cross.platform.kernelArch == "arm") "CONFIG_AEABI=y";
  };

  # Install static binaries as well.
  postInstall = ''
    dir=$out/lib/klibc/bin.static
    mkdir $dir
    cp $(find $(find . -name static) -type f ! -name "*.g" -a ! -name ".*") $dir/
    cp usr/dash/sh $dir/

    for file in ${kernelHeaders}/include/*; do
      ln -sv $file $out/lib/klibc/include
    done
  '';
}
