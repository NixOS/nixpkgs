{ lib
, python3
, fetchFromGitHub

<<<<<<< HEAD
, installShellFiles
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, bubblewrap
, nix-output-monitor
, cacert
, git
, nix

<<<<<<< HEAD
, withAutocomplete ? true
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, withSandboxSupport ? false
, withNom ? false
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nixpkgs-review";
<<<<<<< HEAD
  version = "2.10.1";
  format = "pyproject";
=======
  version = "2.9.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nixpkgs-review";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-zZM0Ozl6uoYfzvHhQRluS4/5NNRuumQgc4MV993LNyY=";
  };

  nativeBuildInputs = [
    installShellFiles
    python3.pkgs.setuptools
  ] ++ lib.optionals withAutocomplete [
    python3.pkgs.argcomplete
  ];

  propagatedBuildInputs = [ python3.pkgs.argcomplete ];

=======
    sha256 = "sha256-9fdoTKaYfqsAXysRwgLq44UrmOGlr5rjF5Ge93PcHDk=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  makeWrapperArgs =
    let
      binPath = [ nix git ]
        ++ lib.optional withSandboxSupport bubblewrap
        ++ lib.optional withNom nix-output-monitor;
    in
    [
      "--prefix PATH : ${lib.makeBinPath binPath}"
      "--set-default NIX_SSL_CERT_FILE ${cacert}/etc/ssl/certs/ca-bundle.crt"
      # we don't have any runtime deps but nix-review shells might inject unwanted dependencies
      "--unset PYTHONPATH"
    ];

  doCheck = false;

<<<<<<< HEAD
  postInstall = lib.optionalString withAutocomplete ''
    for cmd in nix-review nixpkgs-review; do
      installShellCompletion --cmd $cmd \
        --bash <(register-python-argcomplete $out/bin/$cmd) \
        --fish <(register-python-argcomplete $out/bin/$cmd -s fish) \
        --zsh <(register-python-argcomplete $out/bin/$cmd -s zsh)
    done
  '';

  meta = with lib; {
    changelog = "https://github.com/Mic92/nixpkgs-review/releases/tag/${version}";
    description = "Review pull-requests on https://github.com/NixOS/nixpkgs";
    homepage = "https://github.com/Mic92/nixpkgs-review";
    license = licenses.mit;
    mainProgram = "nixpkgs-review";
    maintainers = with maintainers; [ figsoda mic92 ];
=======
  meta = with lib; {
    description = "Review pull-requests on https://github.com/NixOS/nixpkgs";
    homepage = "https://github.com/Mic92/nixpkgs-review";
    changelog = "https://github.com/Mic92/nixpkgs-review/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda mic92 SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
