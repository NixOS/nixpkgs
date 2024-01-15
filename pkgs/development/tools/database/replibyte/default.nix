{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, fetchpatch
, pkg-config
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "replibyte";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "Qovery";
    repo = pname;
    rev = "v${version}";
    sha256 = "02bdz0464d6gbkgbvn67sgn6cc6p6pjqacblh8nimy0r8b13x2ki";
  };

  # Lockfile was updated in a commit after the release
  cargoPatches = [
    (fetchpatch {
      url = "https://github.com/Qovery/Replibyte/commit/15f122cc83fff03ae410be705779ab964fa7b375.patch";
      sha256 = "sha256-v95V4pl/2WN2do2SLVTJIO+5J7esqhC2BZaGBEtDhe0=";
    })
  ];

  cargoSha256 = "sha256-Y9CXpJTY/uszAVAbafa2+FumWKWFGaOLhK1FY+Nc+EU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  cargoBuildFlags = [ "--all-features" ];

  doCheck = false; # requires multiple dbs to be installed

  meta = with lib; {
    description = "Seed your development database with real data";
    homepage = "https://github.com/Qovery/replibyte";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dit7ya ];
  };
}
