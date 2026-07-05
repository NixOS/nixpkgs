{
  lib,
  rustPlatform,
  fetchFromGitHub,
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

  meta = with lib; {
    description = "a simple password manager, built for speed.";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pure-sagacity ];
    homepage = "https://silicate.maariz.org";
    platforms = platforms.unix;
  };
}
