{ gui ? false
, stdenv, fetchurl, makeWrapper
, python, wxPython ? null, pycrypto, twisted
}:

assert gui -> wxPython != null;

stdenv.mkDerivation {
  name = "bittorrent-5.0.3";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://download.bittorrent.com/dl/BitTorrent-5.0.3.tar.gz;
    md5 = "592363a33c35e9f66759a736dbf7e038";
  };
  
  buildInputs = [python pycrypto twisted]
    ++ (if gui then [wxPython] else []);
  
  inherit makeWrapper;

  meta = {
    description = "The original client for the BitTorrent peer-to-peer file sharing protocol";
  };
}
