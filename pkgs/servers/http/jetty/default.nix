{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "jetty-5.1.12";

  src = fetchurl {
    url = ftp://ftp.mortbay.org/pub/jetty-5/jetty-5.1.12.zip;
    sha256 = "04nysajgrlyvfh810jpyr8iay38kwjrbmh6bgs10mwd30qhj4rd1";
  };

  buildInputs = [unzip];

  buildPhase = "true";

  installPhase = ''
    ensureDir $out
    cp -pr * $out/
  '';
}
