{ stdenv, fetchurl, openssl
, zlib
}:

stdenv.mkDerivation rec {
  major = "0";
  minor = "044";
  name = "peervpn-${major}.${minor}";

  src = fetchurl {
    url = "https://peervpn.net/files/peervpn-${major}-${minor}.tar.gz";
    sha256 = "14l3xlps23g9r202b385d8p9rsxrhkcmbd5fp22zz5bdjp7da0j4";
  };


  buildInputs = [ zlib openssl ];

  installPhase = "install -D peervpn $out/bin/peervpn";

  meta = with stdenv; {
    description = "An open source peer-to-peer VPN";
    homepage = https://peervpn.net;
    maintainers = with lib.maintainers; [ hce ];
    platforms = lib.platforms.unix;
    license = licenses.gpl3;
  };
}
