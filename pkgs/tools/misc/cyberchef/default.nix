{ lib, fetchzip, stdenv }:

stdenv.mkDerivation rec {
  pname = "cyberchef";
  version = "9.46.5";

  src = fetchzip {
    url = "https://github.com/gchq/CyberChef/releases/download/v${version}/CyberChef_v${version}.zip";
    sha256 = "sha256-1Snj4rY3elEil7m1n/HFigZWlE2+TJtEiAMjWy0J0xU=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p "$out/share/cyberchef"
    mv "CyberChef_v${version}.html" index.html
    mv * "$out/share/cyberchef"
  '';

  meta = with lib; {
    description = "The Cyber Swiss Army Knife for encryption, encoding, compression and data analysis.";
    homepage = "https://gchq.github.io/CyberChef";
    maintainers = with maintainers; [ sebastianblunt ];
    license = licenses.asl20;
  };
}
