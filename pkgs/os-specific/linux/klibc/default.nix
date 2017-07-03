{ stdenv, fetchurl, linuxHeaders, perl
, buildPlatform, hostPlatform
}:

let
  commonMakeFlags = [
    "prefix=$(out)"
    "SHLIBDIR=$(out)/lib"
  ];
in

stdenv.mkDerivation rec {
  name = "klibc-${version}";
  version = "2.0.4";

  src = fetchurl {
    url = "mirror://kernel/linux/libs/klibc/2.0/klibc-${version}.tar.xz";
    sha256 = "7f9a0850586def7cf4faeeb75e5d0f66e613674c524f6e77b0f4d93a26c801cb";
  };

  patches = [ ./no-reinstall-kernel-headers.patch ];

  nativeBuildInputs = [ perl ];

  hardeningDisable = [ "format" "stackprotector" ];

  makeFlags = commonMakeFlags ++ [
    "KLIBCARCH=${hostPlatform.platform.kernelArch}"
    "KLIBCKERNELSRC=${linuxHeaders}"
  ] # TODO(@Ericson2314): We now can get the ABI from
    # `hostPlatform.parsed.abi`, is this still a good idea?
    ++ stdenv.lib.optional (hostPlatform.platform.kernelArch == "arm") "CONFIG_AEABI=y"
    ++ stdenv.lib.optional (hostPlatform != buildPlatform) "CROSS_COMPILE=${stdenv.cc.prefix}";

  # Install static binaries as well.
  postInstall = ''
    dir=$out/lib/klibc/bin.static
    mkdir $dir
    cp $(find $(find . -name static) -type f ! -name "*.g" -a ! -name ".*") $dir/
    cp usr/dash/sh $dir/

    for file in ${linuxHeaders}/include/*; do
      ln -sv $file $out/lib/klibc/include
    done
  '';

  meta = {
    platforms = [ "x86_64-linux" ];
  };
}
