{ gui ? false
, stdenv, fetchurl, makeWrapper
, python, wxPython ? null, pycrypto, twisted
}:

assert gui -> wxPython != null;

stdenv.mkDerivation {
  name = "bittorrent-5.0.7";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://download.bittorrent.com/dl/BitTorrent-5.0.7.tar.gz;
    sha256 = "09m2qlhzbc6j1hf6fniri0hh6cy6ccgwi2sph65bpjrc417l94gj";
  };
  
  buildInputs = [python pycrypto twisted]
    ++ (if gui then [wxPython] else []);

  inherit makeWrapper;

  meta = {
    description = "The original client for the BitTorrent peer-to-peer file sharing protocol";
  };
}
