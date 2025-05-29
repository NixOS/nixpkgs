{
  lib,
  bootstrapStdenv,
  fetchurl,
  meson,
  ninja,
  stdenv,
}:

# Apple ships libsbuf with macOS 14 but does not provide any source releases.
# Fortunately, it’s a single file library that can be made to build on Darwin using the source from FreeBSD.
bootstrapStdenv.mkDerivation (finalAttrs: {
  pname = "libsbuf";
  version = "14.1.0";

  outputs = [
    "out"
    "dev"
    "man"
  ];

  srcs = [
    (fetchurl {
      name = "subr_sbuf.c";
      url = "https://cgit.freebsd.org/src/plain/sys/kern/subr_sbuf.c?h=release/${finalAttrs.version}";
      hash = "sha256-+wIcXz2wuYzOXmbxjDYBh7lIpoVtw+SW/l7oMXFJUcc=";
    })
    (fetchurl {
      name = "subr_prf.c";
      url = "https://cgit.freebsd.org/src/plain/sys/kern/subr_prf.c?h=release/${finalAttrs.version}";
      hash = "sha256-Sd+kJ7/RwwndK1N6YvqQqPTQRA0ajPAT0yk0rOPRpW8=";
    })
    (fetchurl {
      name = "usbuf.h";
      url = "https://cgit.freebsd.org/src/plain/sys/sys/sbuf.h?h=release/${finalAttrs.version}";
      hash = "sha256-CCwh9kI/X1u16hHWiiBipvBzDKvo2S2OFtI4Jo6HF0E=";
    })
    (fetchurl {
      name = "sbuf.9";
      url = "https://cgit.freebsd.org/src/plain/share/man/man9/sbuf.9?h=release/${finalAttrs.version}";
      hash = "sha256-43uUIGvYX0NvikcGTTJHrokHvubQ89ztLv/BK3MP0YY=";
    })
  ];

  sourceRoot = "source";

  unpackPhase = ''
    runHook preUnpack

    mkdir "$sourceRoot"
    for src in "''${srcs[@]}"; do
      destFilename=$(basename "$src")
      cp "$src" "$sourceRoot/''${src#*-}"
    done

    runHook postUnpack
  '';

  patches = [
    # Fix up sources to build on Darwin and follow the same ABI used by Apple.
    ./patches/0001-darwin-compatibility.patch
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substitute '${./meson.build.in}' "meson.build" --subst-var version
  '';

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
  ];

  __structuredAttrs = true;

  meta = {
    description = "Safely compose and manipulate strings in C";
    homepage = "https://www.freebsd.org";
    license = [
      lib.licenses.bsd2
      lib.licenses.bsd3
    ];
    platforms = lib.platforms.darwin;
  };
})
