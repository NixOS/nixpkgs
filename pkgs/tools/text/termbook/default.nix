{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "termbook-cli";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "termbook";
    rev = "v${version}";
    sha256 = "Bo3DI0cMXIfP7ZVr8MAW/Tmv+4mEJBIQyLvRfVBDG8c=";
  };

  cargoSha256 = "sha256-9fFvJJlDzBmbI7hes/wfjAk1Cl2H55T5n8HLnUmDw/c=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "A runner for `mdbooks` to keep your documentation tested";
    homepage = "https://github.com/Byron/termbook/";
    changelog = "https://github.com/Byron/termbook/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ phaer ];
  };
}
