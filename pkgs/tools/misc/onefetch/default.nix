{ fetchFromGitHub
, rustPlatform
, lib
, stdenv
, fetchpatch
, pkg-config
, zstd
, CoreFoundation
, libiconv
, libresolv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "onefetch";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "o2sh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-16oiZAyj6haBk6mgUT25pPDUrCMd7pGo2kAQ0gTe2kM=";
  };

  cargoPatches = [
    # enable pkg-config feature of zstd
    ./zstd-pkg-config.patch
    # fix flaky test
    (fetchpatch {
      url = "https://github.com/o2sh/onefetch/commit/2c1f2f0b2c666f6ce94af0299f88048dd1d83484.patch";
      sha256 = "sha256-pI3yCFYkqOmLgKnCwexv1LcCrCkhi44zhEAx0szaMkg=";
    })
  ];

  cargoSha256 = "sha256-6wnfn33mfye5o/vY1JQX1Lc4+jzHiKKgGsSLxeJWyFc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zstd ]
    ++ lib.optionals stdenv.isDarwin [ CoreFoundation libiconv libresolv Security ];

  meta = with lib; {
    description = "Git repository summary on your terminal";
    homepage = "https://github.com/o2sh/onefetch";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne kloenk SuperSandro2000 ];
  };
}
