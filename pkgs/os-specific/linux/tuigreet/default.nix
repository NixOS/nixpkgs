{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "tuigreet";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "apognu";
    repo = pname;
    rev = version;
    sha256 = "sha256-Mu4GGlX7ZjBaBECXRD6iJCqDMSzcj17BriJ6Nas0J70=";
  };

  cargoSha256 = "sha256-H5xqk7Yd3M8sFGHlmhAS0fhh3eM4dkvkNQGVxRSXUJs=";

  meta = with lib; {
    description = "Graphical console greter for greetd";
    homepage = "https://github.com/apognu/tuigreet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ivar ];
    platforms = platforms.linux;
  };
}
