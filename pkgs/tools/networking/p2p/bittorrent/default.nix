{ gui ? false
, stdenv, fetchurl, makeWrapper
, python, wxPython ? null, pycrypto, twisted, buildPythonPackage
}:

assert gui -> wxPython != null;

buildPythonPackage rec {
  name = "bittorrent-5.2.2";
  
  src = fetchurl {
    url = http://download.bittorrent.com/dl/archive/BitTorrent-5.2.2.tar.gz;
    sha256 = "05k803hbwsyn51j4aibzdsnqxz24kw4rvr60v2c0wji8gcvy3kx9";
  };
  
  preConfigure = ''
    export HOME=$TMP
  '';

  # accesses network
  doCheck = false;

  buildInputs = [ python pycrypto twisted makeWrapper ]
    ++ stdenv.lib.optional gui wxPython;

  meta = {
    description = "The original client for the BitTorrent peer-to-peer file sharing protocol";
  };
}
