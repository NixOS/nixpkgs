{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, Security
, testers
, lychee
}:

rustPlatform.buildRustPackage rec {
  pname = "lychee";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "lycheeverse";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JUyoOtlypDWK6HxsonVzbfQAdcXk728a8gVI/5GI2fs=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "criterion-0.4.0" = "sha256-0EKLRdxbH2czkZjmuaYLzkTBU687y6Iw9yqNV2TbsDw=";
    };
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  # Disabled because they currently fail
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    inherit version;
    package = lychee;
    command = "lychee --version";
  };

  meta = with lib; {
    description = "A fast, async, resource-friendly link checker written in Rust.";
    homepage = "https://github.com/lycheeverse/lychee";
    changelog = "https://github.com/lycheeverse/lychee/releases/tag/v${version}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ tuxinaut ];
  };
}
