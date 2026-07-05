{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "silicate";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "pure-sagacity";
    repo = "silicate";
    rev = "v${version}";
    hash = "sha256-mtP+W1DYWrzf29HqjsgWECcdxRf6zGtXVvyeyqLhl9E=";
  };

  cargoHash = "sha256-vqmhA/z+aUiSjbmVbpHoCP8T6YQCL+z8Vcix2eq3LIQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Simple password manager built for speed";
    homepage = "https://silicate.maariz.org";
    license = licenses.gpl3;
    maintainers = with maintainers; [ pure-sagacity ];
    mainProgram = "silicate";
    platforms = platforms.unix;
  };
}
