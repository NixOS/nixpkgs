{ lib, fetchzip, stdenv }:

stdenv.mkDerivation rec {
  pname = "cyberchef";
  version = "9.46.0";

  src = fetchzip {
    url = "https://github.com/gchq/CyberChef/releases/download/v${version}/CyberChef_v${version}.zip";
    sha256 = "sha256-4IqXp7fYgXwIuciUklrQoRD2XagatdhQ3l6ghjgTCR8=";
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
