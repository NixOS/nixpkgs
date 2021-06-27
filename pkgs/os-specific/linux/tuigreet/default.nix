{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "tuigreet";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "apognu";
    repo = pname;
    rev = version;
    sha256 = "1v16gl6ajqdbl265nh8akr2far5qhiqv7787hvqlzpr3rd39vnij";
  };

  cargoSha256 = "072zvvgf9m1afjz15m8pwslh2mav37ahjqgg33pdvzdnvg5j1q2h";

  meta = with lib; {
    description = "Graphical console greter for greetd";
    homepage = "https://github.com/apognu/tuigreet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.linux;
  };
}
