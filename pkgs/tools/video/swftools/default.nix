{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation {
  name = "swftools-0.8.1";

  src = fetchurl {
    url = http://www.swftools.org/swftools-0.8.1.tar.gz;
    sha256 = "0l75c3ibwd24g9nqghp1rv1dfrlicw87s0rbdnyffjv4izz6gc2l";
  };

  buildInputs = [ zlib ];

  meta = { 
    description = "Collection of SWF manipulation and creation utilities";
    homepage = http://www.swftools.org/about.html;
    license = "GPLv2";
  };
}
