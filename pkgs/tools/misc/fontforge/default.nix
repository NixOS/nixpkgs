{ stdenv, fetchFromGitHub, fetchpatch, lib, runCommand
, autoconf, automake, gnum4, libtool, perl, gnulib, uthash, pkgconfig, gettext
, python, freetype, zlib, glib, libungif, libpng, libjpeg, libtiff, libxml2, pango
, withSpiro ? false, libspiro
, withGTK ? false, gtk2
, withPython ? true
, Carbon ? null, Cocoa ? null
}:

stdenv.mkDerivation rec {
  name = "fontforge-${version}";
  version = "20170730";

  # The way $version propagates to $version of .pe-scripts (https://github.com/dejavu-fonts/dejavu-fonts/blob/358190f/scripts/generate.pe#L19)
  SOURCE_DATE_EPOCH = lib.fileContents (runCommand "unixtime-of-${version}" {} "date -d ${version} +%s > $out");

  src = fetchFromGitHub {
    owner = "fontforge";
    repo = "fontforge";
    rev = version;
    sha256 = "15k6x97383p8l40jvcivalhwgbbcdg5vciyjz6m9r0lrlnjqkv99";
  };

  patches = [
    ./fontforge-20140813-use-system-uthash.patch

    (fetchpatch {
       url = "https://github.com/fontforge/fontforge/compare/${version}...volth:rb-${version}.patch";
       name = "fontforge-${version}-reproducible-build.patch";
       sha256 = "089w94xnc0ik3rfx9b7q124x9n1nzbyzzcyynl1x31d22byxgl34";
     })
  ];

  # do not use x87's 80-bit arithmetic, rouding errors result in very different font binaries
  NIX_CFLAGS_COMPILE = lib.optionals stdenv.isi686 [ "-msse2" "-mfpmath=sse" ];

  buildInputs = [
    autoconf automake gnum4 libtool perl pkgconfig gettext uthash
    python freetype zlib glib libungif libpng libjpeg libtiff libxml2
  ]
    ++ lib.optionals withSpiro [libspiro]
    ++ lib.optionals withGTK [ gtk2 pango ]
    ++ lib.optionals stdenv.isDarwin [ Carbon Cocoa ];

  configureFlags =
    lib.optionals (!withPython) [ "--disable-python-scripting" "--disable-python-extension" ]
    ++ lib.optional withGTK "--enable-gtk2-use"
    ++ lib.optional (!withGTK) "--without-x";

  # work-around: git isn't really used, but configuration fails without it
  preConfigure = ''
    export GIT="$(type -P true)"
    cp -r "${gnulib}" ./gnulib
    chmod +w -R ./gnulib
    ./bootstrap --skip-git --gnulib-srcdir=./gnulib
  '';

  postInstall =
    # get rid of the runtime dependency on python
    lib.optionalString (!withPython) ''
      rm -r "$out/share/fontforge/python"
    '';

  enableParallelBuilding = true;

  meta = {
    description = "A font editor";
    homepage = http://fontforge.github.io;
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.bsd3;
  };
}

