{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "tuigreet";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "apognu";
    repo = pname;
    rev = version;
    sha256 = "sha256-Exw3HPNFh1yiUfDfaIDiz2PemnVLRmefD4ydgMiHQAc=";
  };

  cargoSha256 = "sha256-/JNGyAEZlb4YilsoXtaXekXNVev6sdVxS4pEcPFh7Bg=";

  meta = with lib; {
    description = "Graphical console greter for greetd";
    homepage = "https://github.com/apognu/tuigreet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.linux;
  };
}
