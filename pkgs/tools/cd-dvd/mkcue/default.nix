{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mkcue-1";

  src = fetchurl {
    url = "https://diplodocus.org/dist/audio/${name}.tar.bz2";
    sha256 = "08md7si3frb8sjfqf3pm7qbrcvkbd10mzszlbydkxnyxdb530b04";
  };

  preInstall = "mkdir -pv $out/bin";
  postInstall = "chmod -v +w $out/bin/mkcue";
}
