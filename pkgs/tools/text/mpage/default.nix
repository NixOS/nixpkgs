{ fetchurl, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "mpage";
<<<<<<< HEAD
  version = "2.5.8";

  src = fetchurl {
    url = "https://www.mesa.nl/pub/mpage/mpage-${version}.tgz";
    sha256 = "sha256-I1HpHSV5SzWN9mGPF6cBOijTUOwgQI/gb4Ej3EZz/pM=";
=======
  version = "2.5.7";

  src = fetchurl {
    url = "https://www.mesa.nl/pub/mpage/mpage-${version}.tgz";
    sha256 = "1zn37r5xrvjgjbw2bdkc0r7s6q8b1krmcryzj0yf0dyxbx79rasi";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    sed -i "Makefile" -e "s|^ *PREFIX *=.*$|PREFIX = $out|g"
    substituteInPlace Makefile --replace 'gcc' '${stdenv.cc.targetPrefix}cc'
  '';

  meta = {
    description = "Many-to-one page printing utility";

    longDescription = ''
      Mpage reads plain text files or PostScript documents and prints
      them on a PostScript printer with the text reduced in size so
      that several pages appear on one sheet of paper.  This is useful
      for viewing large printouts on a small amount of paper.  It uses
      ISO 8859.1 to print 8-bit characters.
    '';

    license = "liberal";  # a non-copyleft license, see `Copyright' file
    homepage = "http://www.mesa.nl/pub/mpage/";
    platforms = lib.platforms.all;
  };
}
