{ lib, fetchFromGitHub, rustPlatform, openssl, pkg-config, stdenv}:

rustPlatform.buildRustPackage rec {
  pname = "gotify-desktop";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = pname;
    rev = version;
    sha256 = "sha256-epolESdf9+2lI+AJ8hMpVPakS1f8fYam+JniiPLIHCs=";
  };

  cargoHash = "sha256-VJ/k6sfBCuokXGpfZ9zGQ7ucbHLweUSgBhlChwko69g=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Small Gotify daemon to send messages as desktop notifications";
    homepage = "https://github.com/desbma/gotify-desktop";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bryanasdev000 genofire ];
    broken = stdenv.isDarwin;
    mainProgram = "gotify-desktop";
  };
}
