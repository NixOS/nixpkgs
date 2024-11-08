{ stdenv, fetchFromGitHub, lib, fetchpatch
, cmake, uthash, pkg-config
, python, freetype, zlib, glib, giflib, libpng, libjpeg, libtiff, libxml2, cairo, pango
, readline, woff2, zeromq
, withSpiro ? false, libspiro
, withGTK ? false, gtk3
, withGUI ? withGTK
, withPython ? true
, withExtras ? true
, Carbon, Cocoa
}:

assert withGTK -> withGUI;

stdenv.mkDerivation rec {
  pname = "fontforge";
  version = "20230101";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-/RYhvL+Z4n4hJ8dmm+jbA1Ful23ni2DbCRZC5A3+pP0=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2024-25081.CVE-2024-25082.patch";
      url = "https://github.com/fontforge/fontforge/commit/216eb14b558df344b206bf82e2bdaf03a1f2f429.patch";
      hash = "sha256-aRnir09FSQMT50keoB7z6AyhWAVBxjSQsTRvBzeBuHU=";
    })
    # Fixes translation compatibility with gettext 0.22
    (fetchpatch {
      url = "https://github.com/fontforge/fontforge/commit/55d58f87ab1440f628f2071a6f6cc7ef9626c641.patch";
      hash = "sha256-rkYnKPXA8Ztvh9g0zjG2yTUCPd3lE1uqwvBuEd8+Oyw=";
    })

    # https://github.com/fontforge/fontforge/pull/5423
    ./replace-distutils.patch
  ];

  # use $SOURCE_DATE_EPOCH instead of non-deterministic timestamps
  postPatch = ''
    find . -type f -name '*.c' -exec sed -r -i 's#\btime\(&(.+)\)#if (getenv("SOURCE_DATE_EPOCH")) \1=atol(getenv("SOURCE_DATE_EPOCH")); else &#g' {} \;
    sed -r -i 's#author\s*!=\s*NULL#& \&\& !getenv("SOURCE_DATE_EPOCH")#g'                            fontforge/cvexport.c fontforge/dumppfa.c fontforge/print.c fontforge/svg.c fontforge/splineutil2.c
    sed -r -i 's#\bb.st_mtime#getenv("SOURCE_DATE_EPOCH") ? atol(getenv("SOURCE_DATE_EPOCH")) : &#g'  fontforge/parsepfa.c fontforge/sfd.c fontforge/svg.c
    sed -r -i 's#^\s*ttf_fftm_dump#if (!getenv("SOURCE_DATE_EPOCH")) ttf_fftm_dump#g'                 fontforge/tottf.c
    sed -r -i 's#sprintf\(.+ author \);#if (!getenv("SOURCE_DATE_EPOCH")) &#g'                        fontforgeexe/fontinfo.c
  '';

  # do not use x87's 80-bit arithmetic, rouding errors result in very different font binaries
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isi686 "-msse2 -mfpmath=sse";

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [
    readline uthash woff2 zeromq
    python freetype zlib glib giflib libpng libjpeg libtiff libxml2
  ]
    ++ lib.optionals withSpiro [ libspiro ]
    ++ lib.optionals withGUI [ gtk3 cairo pango ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Carbon Cocoa ];

  cmakeFlags = [ "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON" ]
    ++ lib.optional (!withSpiro) "-DENABLE_LIBSPIRO=OFF"
    ++ lib.optional (!withGUI) "-DENABLE_GUI=OFF"
    ++ lib.optional (!withGTK) "-DENABLE_X11=ON"
    ++ lib.optional withExtras "-DENABLE_FONTFORGE_EXTRAS=ON";

  preConfigure = ''
    # The way $version propagates to $version of .pe-scripts (https://github.com/dejavu-fonts/dejavu-fonts/blob/358190f/scripts/generate.pe#L19)
    export SOURCE_DATE_EPOCH=$(date -d ${version} +%s)
  '';

  postInstall =
    # get rid of the runtime dependency on python
    lib.optionalString (!withPython) ''
      rm -r "$out/share/fontforge/python"
    '';

  meta = with lib; {
    description = "Font editor";
    homepage = "https://fontforge.github.io";
    platforms = platforms.all;
    license = licenses.bsd3;
    maintainers = [ maintainers.erictapen ];
  };
}
