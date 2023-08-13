{ lib
, rustPlatform
, fetchCrate
}:
rustPlatform.buildRustPackage rec {
  pname = "json2toml";
  version = "0.1.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Zmb3Z5n+qUPMUXXntiXweQKjk2TeZIvcFr6yGuC2AX4=";
  };

  patches = [
    ./no-unstable-features.patch
  ];

  cargoHash = "sha256-x1al3IsYOn4PGYA70CgqypwxF5QiX6+zgURaD9Z7CEw=";

  meta = with lib; {
    homepage = "https://github.com/voidei/json2toml";
    description = "A simple CLI tool that converts json files to toml files.";
    license = licenses.mit;
    maintainers = with maintainers; [ infinisil ];
  };
}
