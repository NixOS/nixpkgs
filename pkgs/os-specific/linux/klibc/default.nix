{ stdenv, fetchurl, kernelHeaders, kernel, perl }:

let
  version = "2.0.2";

  commonMakeFlags = [
    "prefix=$(out)"
    "SHLIBDIR=$(out)/lib"
  ];
in stdenv.mkDerivation {
  name = "klibc-${version}-${kernel.version}";

  src = fetchurl {
    url = "mirror://kernel/linux/libs/klibc/2.0/klibc-${version}.tar.xz";
    sha256 = "1e9d4ba6fe2aeea0bd27d14a9a674c29fb7cf766ff021e9c5f99256cb409474e";
  };

  nativeBuildInputs = [ perl ];

  inherit kernelHeaders;

  patches = [ ./readonly-kernel-source.patch ];

  configurePhase = ''
    ln -sv $kernelHeaders linux
  '';

  makeFlags = commonMakeFlags ++ [
    "KLIBCARCH=${stdenv.platform.kernelArch}"
  ];

  installFlags = [
    "KLIBCKERNELSRC=${kernel.sourceRoot}"
  ];

  crossAttrs = {
    makeFlags = commonMakeFlags ++ [
      "KLIBCARCH=${stdenv.cross.platform.kernelArch}"
      "CROSS_COMPILE=${stdenv.cross.config}-"
    ] ++ stdenv.lib.optional (stdenv.cross.arch == "arm") "CONFIG_AEABI=y";

    installFlags = [
      "KLIBCARCH=${stdenv.cross.platform.kernelArch}"
      "KLIBCKERNELSRC=${kernel.crossDrv.sourceRoot}"
    ];

    kernelHeaders = kernelHeaders.crossDrv;
  };

  # Install static binaries as well.
  postInstall = ''
    dir=$out/lib/klibc/bin.static
    mkdir $dir
    cp $(find $(find . -name static) -type f ! -name "*.g" -a ! -name ".*") $dir/
    cp usr/dash/sh $dir/
  '';
}
