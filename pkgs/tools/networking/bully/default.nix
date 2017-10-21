{stdenv, fetchFromGitHub, openssl, libpcap}:

stdenv.mkDerivation rec {
  name = "bully-${version}";
  version = "1.0-22";
  src = fetchFromGitHub {
    sha256 = "0wk9jmcibd03gspnnr2qvfkw57rg94cwmi0kjpy1mgi05s6vlw1y";
    rev = "v${version}";
    repo = "bully";
    owner = "HorayNarea";
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

  meta = {
    description = "Retrieve WPA/WPA2 passphrase from a WPS enabled access point";
    homepage = https://github.com/Lrs121/bully;
    maintainers = [ stdenv.lib.maintainers.edwtjo ];
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}
