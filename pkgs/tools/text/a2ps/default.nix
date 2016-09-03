{ stdenv, fetchurl, libpaper, gperf, file }:

stdenv.mkDerivation rec {
  name = "a2ps-4.14";
  src = fetchurl {
    url = "mirror://gnu/a2ps/${name}.tar.gz";
    sha256 = "195k78m1h03m961qn7jr120z815iyb93gwi159p1p9348lyqvbpk";
  };

  postPatch = ''
    substituteInPlace afm/make_fonts_map.sh --replace "/bin/rm" "rm"
    substituteInPlace tests/defs.in --replace "/bin/rm" "rm"
  '';

  buildInputs = [ libpaper gperf file ];

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "An Anything to PostScript converter and pretty-printer";
    longDescription = ''
      GNU a2ps converts files into PostScript for printing or viewing. It uses a nice default format,
      usually two pages on each physical page, borders surrounding pages, headers with useful information
      (page number, printing date, file name or supplied header), line numbering, symbol substitution as
      well as pretty printing for a wide range of programming languages.
    '';
    homepage = http://www.inf.enst.fr/~demaille/a2ps/index.html;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.bennofs ];
    platforms = platforms.linux;

  };
}
