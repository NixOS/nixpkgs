{ lib, rustPlatform, fetchFromGitHub, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-readme";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "webern";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FFWHADATEfvZvxGwdkj+eTVoq7pnPuoUAhMGTokUkMs=";
  };

  cargoSha256 = "sha256-OEArMqOiT+PZ+zMRt9h0EzeP7ikFuOYR8mFGtm+xCkQ=";

  # disable doc tests
  cargoTestFlags = [
    "--bins" "--lib"
  ];

  meta = with lib; {
    description = "Generate README.md from docstrings";
    homepage = "https://github.com/livioribeiro/cargo-readme";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ baloo matthiasbeyer ];
  };
}
