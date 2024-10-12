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

  cargoPatches = [
    # Bump `time` and friends to fix compilation with rust 1.80.
    # See https://github.com/NixOS/nixpkgs/issues/332957
    ./0001-update-time.patch
  ];

  cargoHash = "sha256-0UAttCCbSH91Dn7IvEX+Klp/bSYZM4rml7/dD3a208A=";

  nativeBuildInputs = [ pkg-config ];

  # 0.5.6 release has failing tests
  doCheck = false;

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Security SystemConfiguration ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Git prepare-commit-msg hook for authoring commit messages with GPT-3.";
    mainProgram = "gptcommit";
    homepage = "https://github.com/zurawiki/gptcommit";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ happysalada ];
    platforms = with platforms; all;
  };
}

