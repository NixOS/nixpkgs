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
  version = "0.5.6";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "zurawiki";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZrJRXmtwHLUqaYhoAD9lo9k9t06TMGMLf33kgvbC0m8=";
  };

  cargoSha256 = "sha256-625OFsFNNwILAFUC5eWcNETt7F1KpYE1N/Gf8pv9Gbw=";

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

