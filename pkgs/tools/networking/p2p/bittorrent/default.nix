{ gui ? false
, stdenv, fetchurl, makeWrapper
, python, wxPython ? null, pycrypto, twisted
}:

assert gui -> wxPython != null;

stdenv.mkDerivation {
  name = "bittorrent-5.2.0";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://download.bittorrent.com/dl/BitTorrent-5.2.0.tar.gz;
    sha256 = "0lg54x5y2k1cb7vpj7hanlnvzqa2k3v24qq0g6fsycjk4n8dky02";
  };
  
  buildInputs = [python pycrypto twisted makeWrapper]
    ++ stdenv.lib.optional gui wxPython;

  meta = {
    description = "The original client for the BitTorrent peer-to-peer file sharing protocol";
  };
}
