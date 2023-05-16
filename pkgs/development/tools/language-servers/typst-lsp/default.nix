{ lib
, rustPlatform
, fetchFromGitHub
<<<<<<< HEAD
, stdenv
, darwin
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "typst-lsp";
<<<<<<< HEAD
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "nvarner";
    repo = "typst-lsp";
    rev = "v${version}";
    hash = "sha256-rV7vzI4PPyBJX/ofVCXnXd8eH6+UkGaAL7PwhP71t0k=";
=======
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "nvarner";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-bjgGJxAHc3D0j+ZIPPzBw9vJJgchW9hy5E/qCmFjDUw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
<<<<<<< HEAD
      "typst-0.7.0" = "sha256-yrtOmlFAKOqAmhCP7n0HQCOQpU3DWyms5foCdUb9QTg=";
      "typstfmt_lib-0.2.0" = "sha256-DOh7WQowJXTxI9GDXfy73hvr3J+VcDqSDaClLlUpMsM=";
    };
  };

  patches = [
    # update typstfmt to symlink its README.md into the library crate
    # without this patch, typst-lsp fails to build when dependencies are vendored
    # https://github.com/astrale-sharp/typstfmt/pull/81
    ./update-typstfmt.patch
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  checkFlags = [
    # requires internet access
    "--skip=workspace::package::external::remote_repo::test::full_download"
  ];

  # workspace::package::external::manager::test::local_package tries to access the data directory
  preCheck = ''
    export HOME=$(mktemp -d)
  '';
=======
      "elsa-1.8.1" = "sha256-/85IriplPxx24TE/CsvjIsve100QUZiVqS0TWgPFRbw=";
      "typst-0.2.0" = "sha256-3vNJmLmbskAzXVXjiSVDLhRcX1j3ksOgPd53W31YZ0c=";
    };
  };

  cargoHash = "sha256-ISkw0lhUKJG8nWUHcR93sLUFt5dDEyK7EORcOXEmVbE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A brand-new language server for Typst";
    homepage = "https://github.com/nvarner/typst-lsp";
    changelog = "https://github.com/nvarner/typst-lsp/releases/tag/${src.rev}";
<<<<<<< HEAD
    license = with licenses; [ asl20 mit ];
=======
    license = with licenses; [ mit ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ figsoda GaetanLepage ];
  };
}
