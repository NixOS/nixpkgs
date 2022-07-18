{ lib, nimPackages, fetchFromGitHub }:

nimPackages.buildNimPackage rec {
  pname = "tridactly-native";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "tridactyl";
    repo = "native_messenger";
    rev = "5cc315da79a1caa8fd5b27b192377d8824a311c1";
    sha256 = "sha256-9IyVDJgdZleeNltD1b4PfqxeWAtFsPHtmq1ZC5Z0O9k=";
  };
  buildInputs = with nimPackages; [ tempfile ];

  installPhase = ''
    mkdir -p "$out/lib/mozilla/native-messaging-hosts"
    sed -i -e "s|REPLACE_ME_WITH_SED|$out/bin/native_main|" "tridactyl.json"
    cp tridactyl.json "$out/lib/mozilla/native-messaging-hosts/"
  '';

  meta = with lib; {
    description =
      "Native messenger for Tridactyl, a vim-like Firefox webextension";
    homepage = "https://github.com/tridactyl/native_messenger";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ timokau dit7ya ];
  };
}
