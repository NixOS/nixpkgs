{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, Security
, testVersion
, igrep
}:

rustPlatform.buildRustPackage rec {
  pname = "igrep";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "konradsz";
    repo = "igrep";
    rev = "v${version}";
    sha256 = "sha256-ZbJogp4rTc3GAD71iQUIf5EqwJ8XD9/WmvdAcGIgcvY=";
  };

  cargoSha256 = "sha256-sj2GEyUPq9+JXlGpKYRNfhfwGf5F/J46AoOjUu4xm7I=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  passthru.tests = {
    version = testVersion { package = igrep; command = "ig --version"; };
  };

  meta = with lib; {
    description = "Interactive Grep";
    homepage = "https://github.com/konradsz/igrep";
    license = licenses.mit;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
