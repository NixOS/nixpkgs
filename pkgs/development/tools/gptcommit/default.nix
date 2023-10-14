{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, nix-update-script
, Security
, openssl
}:

let
  pname = "gptcommit";
  version = "0.5.13";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "zurawiki";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-O0dqLN2wDXRIVcb9whlzK0BJOm/qhTH+nLpCwSUObng=";
  };

  cargoSha256 = "sha256-JwwQaThefWhJVRJ/a0WfdKJqr/NHgll6D6Y2QaeqWsc=";

  nativeBuildInputs = [ pkg-config ];

  # 0.5.6 release has failing tests
  doCheck = false;

  buildInputs = lib.optionals stdenv.isDarwin [ Security ] ++ lib.optionals stdenv.isLinux [ openssl ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A git prepare-commit-msg hook for authoring commit messages with GPT-3. ";
    homepage = "https://github.com/zurawiki/gptcommit";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ happysalada ];
    platforms = with platforms; all;
  };
}

