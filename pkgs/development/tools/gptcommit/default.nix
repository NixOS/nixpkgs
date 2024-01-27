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
  version = "0.5.14";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "zurawiki";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xjaFr1y2Fd7IWbJlegnIsfS5/oMJYd6QTnwp7IK17xM=";
  };

  cargoHash = "sha256-VZrlEJi/UPQTGFiSpZs+Do+69CY3zdqGkAnUxMYvvaw=";

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
    homepage = "https://github.com/zurawiki/gptcommit";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ happysalada ];
    platforms = with platforms; all;
  };
}

