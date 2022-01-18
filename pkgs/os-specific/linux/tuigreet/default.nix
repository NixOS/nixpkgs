{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "tuigreet";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "apognu";
    repo = pname;
    rev = version;
    sha256 = "sha256-Ecp79q/xN6KDAD346ANzunTM3xW+z5UaRy/lblOCLaE=";
  };

  cargoSha256 = "sha256-eam+85c2y+eNSOlfhO7oIhGqy0HPyi3FuqxHBDkZRVE=";

  meta = with lib; {
    description = "Graphical console greter for greetd";
    homepage = "https://github.com/apognu/tuigreet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ivar ];
    platforms = platforms.linux;
  };
}
