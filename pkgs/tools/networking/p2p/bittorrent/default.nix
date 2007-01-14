{ gui ? false
, stdenv, fetchurl, makeWrapper
, python, wxPython ? null, pycrypto, twisted
}:

assert gui -> wxPython != null;

stdenv.mkDerivation {
  name = "bittorrent-5.0.4";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://download.bittorrent.com/dl/BitTorrent-5.0.4.tar.gz;
    md5 = "3f6a1093102541e88a16d6c1c62e8bcc";
  };
  
  buildInputs = [python pycrypto twisted]
    ++ (if gui then [wxPython] else []);
  
  inherit makeWrapper;

  meta = {
    description = "The original client for the BitTorrent peer-to-peer file sharing protocol";
  };
}
