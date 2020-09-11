{ stdenv, fetchurl, lib
, fetchpatch
, cmake, perl, uthash, pkgconfig, gettext
, python, freetype, zlib, glib, libungif, libpng, libjpeg, libtiff, libxml2, cairo, pango
, readline, woff2, zeromq, libuninameslist
, withSpiro ? false, libspiro
, withGTK ? false, gtk3
, withGUI ? withGTK
, withPython ? true
, withExtras ? true
, Carbon ? null, Cocoa ? null
}:

assert withGTK -> withGUI;

stdenv.mkDerivation rec {
  pname = "fontforge";
  version = "20200314";

  src = fetchurl {
    url = "https://github.com/${pname}/${pname}/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "0qf88wd6riycq56d24brybyc93ns74s0nyyavm43zp2kfcihn6fd";
  };

  patches = [
    # Unreleased fix for https://github.com/fontforge/fontforge/issues/4229
    # which is required to fix an uninterposated `${CMAKE_INSTALL_PREFIX}/lib`, see
    # see https://github.com/nh2/static-haskell-nix/pull/98#issuecomment-665395399
    # TODO: Remove https://github.com/fontforge/fontforge/pull/4232 is in a release.
    (fetchpatch {
      name = "fontforge-cmake-set-rpath-to-the-configure-time-CMAKE_INSTALL_PREFIX";
      url = "https://github.com/fontforge/fontforge/commit/297ee9b5d6db5970ca17ebe5305189e79a1520a1.patch";
      sha256 = "14qfp8pwh0vzzib4hq2nc6xhn8lc1cal1sb0lqwb2q5dijqx5kqk";
    })
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
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isi686 "-msse2 -mfpmath=sse";

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [
    readline uthash woff2 zeromq libuninameslist
    python freetype zlib glib libungif libpng libjpeg libtiff libxml2
  ]
    ++ lib.optionals withSpiro [libspiro]
    ++ lib.optionals withGUI [ gtk3 cairo pango ]
    ++ lib.optionals stdenv.isDarwin [ Carbon Cocoa ];

  cmakeFlags = [ "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON" ]
    ++ lib.optional (!withSpiro) "-DENABLE_LIBSPIRO=OFF"
    ++ lib.optional (!withGUI) "-DENABLE_GUI=OFF"
    ++ lib.optional (!withGTK) "-DENABLE_X11=ON"
    ++ lib.optional withExtras "-DENABLE_FONTFORGE_EXTRAS=ON";

  # work-around: git isn't really used, but configuration fails without it
  preConfigure = ''
    # The way $version propagates to $version of .pe-scripts (https://github.com/dejavu-fonts/dejavu-fonts/blob/358190f/scripts/generate.pe#L19)
    export SOURCE_DATE_EPOCH=$(date -d ${version} +%s)
  '';

  postInstall =
    # get rid of the runtime dependency on python
    lib.optionalString (!withPython) ''
      rm -r "$out/share/fontforge/python"
    '';

  meta = {
    description = "A font editor";
    homepage = "http://fontforge.github.io";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.erictapen ];
  };
}
