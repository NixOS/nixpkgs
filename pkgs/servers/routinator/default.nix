{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ThgTGtTZ0LGm9nHJoy0KhnBFWNvKRjk7hoNTVVTeL/Y=";
  };

  cargoSha256 = "sha256-mcx+qUtTUxeYP0PeJp1eOQwsdS6PPUx/m7TfAyqFiIM=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoBuildFlags = [ "--no-default-features" "--features=socks" ];

  cargoTestFlags = cargoBuildFlags;

  meta = with lib; {
    description = "An RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    changelog = "https://github.com/NLnetLabs/routinator/blob/v${version}/Changelog.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
