{ stdenv, fetchurl, fetchgit, rsync, lilypond, gyre-fonts }:

with stdenv.lib;

let urw-fonts = fetchgit {
  url = "http://git.ghostscript.com/urw-core35-fonts.git";
  rev = "1f28a6fcd2176256a995db907d9ffe6e1b9b83e9";
  sha256 = "1nlx95l1pw5lxqp2v0rn9a7lqrsbbhzr0dy3cybk55r4a8awbr2a";
}; in

overrideDerivation lilypond (p: rec {
  majorVersion = "2.19";
  minorVersion = "65";
  version="${majorVersion}.${minorVersion}";
  name = "lilypond-${version}";

  src = fetchurl {
    url = "http://download.linuxaudio.org/lilypond/sources/v${majorVersion}/lilypond-${version}.tar.gz";
    sha256 = "0k2jy7z58j62c5cv1308ac62d6jri17wip76xrbq8s6jq6jl7phd";
  };

  configureFlags = [ "--disable-documentation" "--with-urwotf-dir=${urw-fonts}" "--with-texgyre-dir=${gyre-fonts}/share/fonts/truetype/"];

  buildInputs = p.buildInputs ++ [ rsync ];

})
