{ stdenv, fetchurl, pkgconfig, autoreconfHook, check }:

stdenv.mkDerivation rec {
  name = "substitute-0.1.0";
  
  src = fetchurl {
    url = "http://github.com/wkennington/substitute/archive/v0.1.0.tar.gz";
    sha256 = "0m4hyz39sp1y8fa8v8zmqwyl347ml5qffcivk7c6qchvb9vs1man";
  };

  buildInputs = [ pkgconfig autoreconfHook check ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A simple utility for replacing strings within a file.";
    homepage = "https://github.com/wkennington/substitute";
    license = licenses.mit;
    platform = platforms.unix;
  };
}
