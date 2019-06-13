{stdenv, fetchFromGitHub, zlib, libpng, libxml2, libjpeg }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "flam3";
  version = "3.1.1-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "e0801543538451234d7a8a240ba3b417cbda5b21";

  src = fetchFromGitHub {
    inherit rev;
    owner = "scottdraves";
    repo = "${pname}";
    sha256 = "18iyj16k0sn3fs52fj23lj31xi4avlddhbib6kk309576nlxp17w";
  };

  buildInputs = [ zlib libpng libxml2 libjpeg ];

  meta = with stdenv.lib; {
    description = "Cosmic recursive fractal flames";
    homepage = https://flam3.com/;
    maintainers = [ maintainers.nand0p ];
    platforms = platforms.linux;
    license = licenses.cc-by-nc-sa-20;
  };
}
