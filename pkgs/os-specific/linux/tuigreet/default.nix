{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "tuigreet";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "apognu";
    repo = pname;
    rev = version;
    sha256 = "sha256-Ip/GhpHgTgWFyCdujcCni1CLFDDirUbJuzCj8QiUsFc=";
  };

  cargoSha256 = "sha256-G/E/2wjeSY57bQJgrZYUA1sWUwtk5mRavmLwy1EgHRM=";

  meta = with lib; {
    description = "Graphical console greter for greetd";
    homepage = "https://github.com/apognu/tuigreet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.linux;
  };
}
