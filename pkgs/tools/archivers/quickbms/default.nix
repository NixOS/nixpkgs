{
  pkgsi686Linux,
  lib,
  fetchzip,
  fetchpatch,
  bzip2,
  lzo,
  openssl,
  opensslSupport ? false,
  zlib,
}:

pkgsi686Linux.stdenv.mkDerivation rec {

  #TODO: assert that GCC is used, other compilers are not supported

  version = "0.12.0";
  pname = "quickbms";

  src = fetchzip {
    url = "https://aluigi.altervista.org/papers/quickbms-src-${version}.zip";
    hash = "sha256-thD4wYjiYuwCzjuXmhVfMEhhlSHHOLa5yl0uDhF6aMA=";
  };

  patches = [
    # Fix errors on x86_64 and OpenSSL compatibility
    (fetchpatch {
      name = "0001-fix-openssl-v21-padding-deprecation.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/0001-Fix-OpenSSL-V21-padding-deprecation.patch?h=quickbms";
      hash = "sha256-QFuReSEJ6XsQbGc3DW40ZRXVe/xv8cr1IAXts9P3yY4=";
    })
    (fetchpatch {
      name = "0002-fix-compile-x86.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/0002-fix-compile-x86.patch?h=quickbms";
      hash = "sha256-LaLs64M0lPTOuvhWX5tC2qt/4MxwDvR7X0hnpL1xbF0=";
    })
    ./0004-no-atomics.patch
  ] ++ lib.optional (!opensslSupport) ./0003-disable-openssl.patch;

  buildInputs = [
    bzip2
    lzo
    zlib
  ] ++ lib.optional (opensslSupport) openssl;

  env.NIX_CFLAGS_COMPILE = builtins.toString [
    "-Wno-error=implicit-function-declaration" # upstream code is a bit sloppy
    "-Wno-error=incompatible-pointer-types" # three instances in upstream code (intentional?)
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Universal script based file extractor and reimporter";
    homepage = "https://aluigi.altervista.org/quickbms.htm";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "quickbms";
  };
}
