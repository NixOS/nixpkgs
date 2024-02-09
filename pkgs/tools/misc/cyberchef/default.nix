{ lib
, fetchzip
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "cyberchef";
  version = "10.6.0";

  src = fetchzip {
    url = "https://github.com/gchq/CyberChef/releases/download/v${version}/CyberChef_v${version}.zip";
    sha256 = "sha256-vJ2NbD0SqUd5HKkjaZXPxn48xC1vMS95dnmp+u2W1SM=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p "$out/share/cyberchef"
    mv "CyberChef_v${version}.html" index.html
    mv * "$out/share/cyberchef"
  '';

  meta = with lib; {
    description = "The Cyber Swiss Army Knife for encryption, encoding, compression and data analysis";
    homepage = "https://gchq.github.io/CyberChef";
    changelog = "https://github.com/gchq/CyberChef/blob/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ sebastianblunt ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
