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
      url = "http://deb.debian.org/debian/pool/main/b/blt/blt_${finalAttrs.version}+dfsg-8.debian.tar.xz";
      hash = "sha256-tuXCdZazNedFvqWZxuLCjsenCUqIhZymvGAvuJFgyuk=";
    })
  ];

  sourceRoot = "blt${majorMinor finalAttrs.version}";

  patches = lib.lists.map (patch: "../debian/patches/${patch}") [
    # taken verbatim from https://sources.debian.org/src/blt/2.5.3%2Bdfsg-8/debian/patches/series
    "02-debian-all.patch"
    "03-fedora-patch-2.patch"
    "04-fedora-tk8.5.6.patch"
    "05-tk8.5-zoomstack.patch"
    "doc-typos.patch"
    "tcl8.6.patch"
    "tk8.6.patch"
    "install.patch"
    "usetclint.patch"
    "usetkint.patch"
    "table.patch"
    "ldflags.patch"
    "pkgindex.patch"
    "decls.patch"
    "bltnsutil.patch"
    "blthash.patch"
    "const.patch"
    "uninitialized.patch"
    "unused.patch"
    "pointertoint.patch"
    "autoreconf.patch"
    "gcc-15.patch"
  ];

  postPatch = ''
    substituteInPlace configure --replace-fail 'ac_cv_sizeof_void_p=0' \
      'ac_cv_sizeof_void_p=${
        builtins.toString (
          if stdenv.hostPlatform.is32bit then
            4
          else if stdenv.hostPlatform.is64bit then
            8
          else
            abort "only 32 bit and 64 bit is supported"
        )
      }'
  '';

  nativeBuildInputs = [ unzip ];
  buildInputs = [
    libx11
    libxext
    tcl
    tk
    tk.dev
  ];

  configureFlags = [
    "--with-tk=${tk}/lib"
    "--with-tkincls=${tk.dev}/include"
    "--x-includes=${libxext}/include"
    "--x-libraries=${libx11}/lib"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-old-style-definition";
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
    description = "BLT for Tcl/Tk with patches from Debian";
    license = lib.licenses.tcltk;
    platforms = lib.platforms.unix;
  };
})
