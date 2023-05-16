{ lib
, fetchzip
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "cyberchef";
<<<<<<< HEAD
  version = "10.5.2";

  src = fetchzip {
    url = "https://github.com/gchq/CyberChef/releases/download/v${version}/CyberChef_v${version}.zip";
    sha256 = "sha256-sN8dCgmLj0jHfoaUNk2ml/iEJy8/QFfCTRCn9tyTz78=";
=======
  version = "10.4.0";

  src = fetchzip {
    url = "https://github.com/gchq/CyberChef/releases/download/v${version}/CyberChef_v${version}.zip";
    sha256 = "sha256-BjdeOTVZUMitmInL/kE6a/aw/lH4YwKNWxdi0B51xzc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    changelog = "https://github.com/gchq/CyberChef/blob/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ sebastianblunt ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
