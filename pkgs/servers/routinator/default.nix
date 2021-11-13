{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0a2iwpmljkha6qlbw0373wph7pxz05qym5712vzbszw0z42f82l2";
  };

  cargoSha256 = "0l3fhwgrdvjrlmiqdy90sfd8kb2s7y0lbfswlrr560ly0bi1lfbx";

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
