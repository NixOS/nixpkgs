{ stdenv, fetchFromGitHub, fetchpatch, lib
, autoconf, automake, gnum4, libtool, git, perl, gnulib, uthash, pkgconfig, gettext
, python, freetype, zlib, glib, libungif, libpng, libjpeg, libtiff, libxml2, pango
, withGTK ? false, gtk2
, withPython ? true
, Carbon ? null, Cocoa ? null
}:

stdenv.mkDerivation rec {
  name = "fontforge-${version}";
  version = "20160404";

  src = fetchFromGitHub {
    owner = "fontforge";
    repo = "fontforge";
    rev = version;
    sha256 = "15nacq84n9gvlzp3slpmfrrbh57kfb6lbdlc46i7aqgci4qv6fg0";
  };

  patches = [(fetchpatch {
    name = "use-system-uthash.patch";
    url = "http://pkgs.fedoraproject.org/cgit/fontforge.git/plain/"
      + "fontforge-20140813-use-system-uthash.patch?id=8bdf933";
    sha256 = "0n8i62qv2ygfii535rzp09vvjx4qf9zp5qq7qirrbzm1l9gykcjy";
  })];
  patchFlags = "-p0";

  # FIXME: git isn't really used, but configuration fails without it
  buildInputs = [
    git autoconf automake gnum4 libtool perl pkgconfig gettext uthash
    python freetype zlib glib libungif libpng libjpeg libtiff libxml2
  ]
    ++ lib.optionals withGTK [ gtk2 pango ]
    ++ lib.optionals stdenv.isDarwin [ Carbon Cocoa ];

  configureFlags =
    lib.optionals (!withPython) [ "--disable-python-scripting" "--disable-python-extension" ]
    ++ lib.optional withGTK "--enable-gtk2-use"
    ++ lib.optional (!withGTK) "--without-x";

  preConfigure = ''
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
  };
}

