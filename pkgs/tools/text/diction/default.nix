{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "diction-1.11";

  src = fetchurl {
    url = "mirror://gnu/diction/${name}.tar.gz";
    sha256 = "1xi4l1x1vvzmzmbhpx0ghmfnwwrhabjwizrpyylmy3fzinzz3him";
  };

  meta = {
    description = "GNU style and diction utilities";
    longDescription = ''
      Diction and style are two old standard Unix commands. Diction identifies
      wordy and commonly misused phrases. Style analyses surface
      characteristics of a document, including sentence length and other
      readability measures.
    '';
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
