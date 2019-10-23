{ stdenv, fetchFromGitHub, openssl, libpcap }:

stdenv.mkDerivation rec {

  pname = "bully";
  version = "1.1";

  src = fetchFromGitHub {
    sha256 = "1qvbbf72ryd85bp4v62fk93ag2sn25rj7kipgagbv22hnq8yl3zd";
    rev = version;
    repo = "bully";
    owner = "aanarchyy";
  };
  buildInputs = [ openssl libpcap ];

  buildPhase = ''
    cd src
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv bully $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Retrieve WPA/WPA2 passphrase from a WPS enabled access point";
    homepage = https://github.com/aanarchyy/bully;
    maintainers = with maintainers; [ edwtjo ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
