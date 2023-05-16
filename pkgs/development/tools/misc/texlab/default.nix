{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, help2man
, installShellFiles
, libiconv
, Security
, CoreServices
, nix-update-script
}:

let
  isCross = stdenv.hostPlatform != stdenv.buildPlatform;
in
rustPlatform.buildRustPackage rec {
  pname = "texlab";
<<<<<<< HEAD
  version = "5.9.2";
=======
  version = "5.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "latex-lsp";
    repo = "texlab";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-ZWvxi000wxjCzAe8PnzLb3z7smBc95gky0WyrkzVmEc=";
  };

  cargoHash = "sha256-ohovhwm/lIcNRorHtiluBVVVLIsaft/godDmte2hl9M=";
=======
    hash = "sha256-8m7GTD4EX7mWe1bYPuz+4g7FaPuW8++Y/fpIRsdxo6g=";
  };

  cargoHash = "sha256-dcKVhHYODTFw46o3wM8EH0IpT6DkUfOHvdDmbMQmsX0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [ "out" ] ++ lib.optional (!isCross) "man";

  nativeBuildInputs = [ installShellFiles ]
    ++ lib.optional (!isCross) help2man;

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
    Security
    CoreServices
  ];

  # When we cross compile we cannot run the output executable to
  # generate the man page
  postInstall = lib.optionalString (!isCross) ''
    # TexLab builds man page separately in CI:
<<<<<<< HEAD
    # https://github.com/latex-lsp/texlab/blob/v5.9.2/.github/workflows/publish.yml#L117-L121
=======
    # https://github.com/latex-lsp/texlab/blob/v5.5.1/.github/workflows/publish.yml#L127-L131
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    help2man --no-info "$out/bin/texlab" > texlab.1
    installManPage texlab.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "An implementation of the Language Server Protocol for LaTeX";
    homepage = "https://github.com/latex-lsp/texlab";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar kira-bruneau ];
    platforms = platforms.all;
  };
}
