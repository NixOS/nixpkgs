{ stdenv, fetchurl, fetchpatch, lib
, autoconf, automake, gnum4, libtool, git, perl, gnulib, uthash, pkgconfig, gettext
, python, freetype, zlib, glib, libungif, libpng, libjpeg, libtiff, libxml2, pango
, withGTK ? false, gtk2
, withPython ? false # python-scripting was breaking inconsolata and libertine builds
}:

let
  version = "20150824"; # also tagged v2.1.0
in

stdenv.mkDerivation {
  name = "fontforge-${version}";

  src = fetchurl {
    url = "https://github.com/fontforge/fontforge/archive/${version}.tar.gz";
    sha256 = "09zzg166lw5ldbzsa2j9x7hizn6y3ld1kf4abfkiy301rdqj9ar8";
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
    pango
  ]
    ++ lib.optionals withGTK [ gtk2 ];

  configureFlags =
    lib.optionals (!withPython) [ "--disable-python-scripting" "--disable-python-extension" ]
    ++ lib.optional withGTK "--enable-gtk2-use";

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

