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
    sha256 = "sha256-OjL3wEoh4fT2nKqb7lMefP5B0vYyUaTRj09OXPEVfW4=";
  };

  cargoSha256 = "sha256-CL6VXe7heyBbGX0qI4uaD7g7DLiFbykSfOcWemnEe8U=";

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
