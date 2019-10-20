{ stdenv, fetchFromGitHub
, cmake, gengetopt
, libnfc, libusb }:

stdenv.mkDerivation rec {
  pname = "ykchalresp-nfc";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Frederick888";
    repo = "ykchalresp-nfc";
    rev = "v${version}";
    sha256 = "0q5j4k88cbrpz9kypdhkf03m7wdhzpvs1zj4m7sdhyhgf5yvhqgr";
  };

  buildInputs = [ libnfc libusb ];

  nativeBuildInputs = [ cmake gengetopt ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp --target-directory=$out/bin ykchalresp-nfc

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Perform challenge response using YubiKey via NFC.";
    homepage = https://github.com/Frederick888/ykchalresp-nfc;
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
