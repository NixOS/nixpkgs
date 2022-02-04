{ lib
, stdenv
, fetchFromGitea
, rustPlatform
, pkg-config
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "fedigroups";
  version = "0.4.4";

  src = fetchFromGitea {
    domain = "git.ondrovo.com";
    owner = "MightyPork";
    repo = "group-actor";
    rev = "v${version}";
    sha256 = "sha256-1WqIQp16bs+UB+NSEZn0JH6NOkuAx8iUfho4roA2B00=";
  };

  cargoHash = "sha256-88ToWRkBDXUvnEB2K6q5f3+IMuC3zNzrXrVFZnjbA9o=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    homepage = "https://git.ondrovo.com/MightyPork/group-actor#fedi-groups";
    downloadPage = "https://git.ondrovo.com/MightyPork/group-actor/releases";
    description = "An approximation of groups usable with Fediverse software that implements the Mastodon client API";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}
