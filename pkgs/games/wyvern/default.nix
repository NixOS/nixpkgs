{ lib
, fetchCrate
, rustPlatform
, cmake
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "wyvern";
  version = "1.4.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-OjL3wEoh4fT2nKqb7lMefP5B0vYyUaTRj09OXPEVfW4=";
  };

  cargoPatches = [ ./cargo-lock.patch ];

  cargoHash = "sha256-cwk8yFt8JrYkYlNUW9n/bgMUA6jyOpG0TSh5C+eERLY=";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ openssl ];

  meta = with lib; {
    description = "A simple CLI client for installing and maintaining linux GOG games";
    homepage = "https://git.sr.ht/~nicohman/wyvern";
    license = licenses.gpl3;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.linux;
  };
}
