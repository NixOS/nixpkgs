{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "fast-ssh";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "julien-r44";
    repo = "fast-ssh";
    rev = "v${version}";
    sha256 = "sha256-eHJdMe8RU6Meg/9+NCfIneD5BqNUc2yIiQ8Z5UqUBUI=";
  };

  cargoSha256 = "sha256-sIQNoH3UWX3SwCFCPZEREIFR7C28ml4oGsrq6wuOAT0=";

  patches = [
    # Can be removed as soon as this is is merged: https://github.com/Julien-R44/fast-ssh/pull/22
    (fetchpatch {
      name = "fix-ambiguous-as_ref.patch";
      url = "https://github.com/Julien-R44/fast-ssh/commit/c082a64a4b412380b2ab145c24161fdaa26175db.patch";
      hash = "sha256-egkoJF+rQiuClNL8ltzmB7oHngbpOxO29rlwZ3nELOE=";
    })
  ];

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "TUI tool to use the SSH config for connections";
    homepage = "https://github.com/julien-r44/fast-ssh";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "fast-ssh";
  };
}
