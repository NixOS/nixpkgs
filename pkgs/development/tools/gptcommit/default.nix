{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, nix-update-script
, Security
, SystemConfiguration
, openssl
}:

let
  pname = "gptcommit";
  version = "0.5.16";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "zurawiki";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JhMkK2zw3VL9o7j8DJmjY/im+GyCjfV2TJI3GDo8T8c=";
  };

  cargoHash = "sha256-ye9MAfG3m24ofV95Kr+KTP4FEqfrsm3aTQ464hG9q08=";

  nativeBuildInputs = [ pkg-config ];

  # 0.5.6 release has failing tests
  doCheck = false;

  buildInputs = lib.optionals stdenv.isDarwin [ Security SystemConfiguration ]
    ++ lib.optionals stdenv.isLinux [ openssl ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A git prepare-commit-msg hook for authoring commit messages with GPT-3. ";
    mainProgram = "gptcommit";
    homepage = "https://github.com/zurawiki/gptcommit";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ happysalada ];
    platforms = with platforms; all;
  };
}

