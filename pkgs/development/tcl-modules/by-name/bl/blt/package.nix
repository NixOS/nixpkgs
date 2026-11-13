{
  lib,
  stdenv,
  fetchurl,
  unzip,
  libx11,
  libxext,
  tcl,
  tk,
}:

let
  inherit (lib.versions) majorMinor;
in
tcl.mkTclDerivation (finalAttrs: {
  pname = "blt";
  version = "2.5.3";

  srcs = [
    (fetchurl {
      url = "mirror://sourceforge/wize/blt-src-${finalAttrs.version}.zip";
      hash = "sha256-bsd49Y9g8X4kEVbQDn5sp5k4/0D9Yd99I83t/n7EmUM=";
    })

    # Debian maintains a hefty set of patches
    (fetchurl {
      url = "https://deb.debian.org/debian/pool/main/b/blt/blt_${finalAttrs.version}+dfsg-10.debian.tar.xz";
      hash = "sha256-avJrs/uEvOp+Q1NNDYAQCACcoPKncXLeBil2K1/xAMo=";
    })
  ];

  sourceRoot = "blt${majorMinor finalAttrs.version}";

  prePatch = ''
    mapfile -t debianPatches < <(sed '/^#/d;s|^|../debian/patches/|' ../debian/patches/series)
    concatTo patches debianPatches
  '';

  postPatch = ''
    substituteInPlace configure --replace-fail 'ac_cv_sizeof_void_p=0' \
      'ac_cv_sizeof_void_p=${
        if stdenv.hostPlatform.is32bit then
          "4"
        else if stdenv.hostPlatform.is64bit then
          "8"
        else
          throw "tclPackages.blt only supports 32 bit and 64 bit"
      }'
  '';

  nativeBuildInputs = [ unzip ];
  buildInputs = [
    libx11
    libxext
    tcl
    tk
  ];

  configureFlags = [
    "--with-tk=${lib.getLib tk}/lib"
    "--with-tkincls=${lib.getInclude tk}/include"
    "--x-includes=${lib.getInclude libxext}/include"
    "--x-libraries=${lib.getLib libx11}/lib"
  ];

  hardeningDisable = [
    # Avoid
    # *** buffer overflow detected ***: terminated
    "fortify"
  ];

  # The makefiles use `mkdir` racy, and subsequent `mkdir foo` calls fail
  enableParallelBuilding = false;

  preFixup = ''
    substituteInPlace $out/lib/blt${majorMinor finalAttrs.version}/pkgIndex.tcl \
     --replace-fail '@BLT_PATCH_LEVEL@' ${lib.strings.escapeShellArg finalAttrs.version}
  '';

  meta = {
    homepage = "https://sourceforge.net/projects/wize/";
    description = "Graphics extension library for Tcl/Tk";
    license = lib.licenses.tcltk;
    maintainers = with lib.maintainers; [ wucke13 ];
    broken = tcl.isTcl9 || stdenv.hostPlatform.isDarwin;
  };
})
