{ stdenv, fetchurl, guile, rsync, lilypond }:

with stdenv.lib;

overrideDerivation lilypond (p: rec {
  majorVersion = "2.19";
  minorVersion = "24";
  version="${majorVersion}.${minorVersion}";
  name = "lilypond-${version}";

  src = fetchurl {
    url = "http://download.linuxaudio.org/lilypond/sources/v${majorVersion}/lilypond-${version}.tar.gz";
    sha256 = "0wd57swrfc2nvkj10ipdbhq6gpnckiafg2b2kpd8aydsyp248iln";
  };

  configureFlags = [ "--disable-documentation" "--with-fonts-dir=${p.urwfonts}"];

  buildInputs = p.buildInputs ++ [ rsync ];

})
