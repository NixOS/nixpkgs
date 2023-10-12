{ lib
, python3
, fetchFromGitHub

, installShellFiles
, bubblewrap
, nix-output-monitor
, cacert
, git
, nix

, withAutocomplete ? true
, withSandboxSupport ? false
, withNom ? false
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nixpkgs-review";
  version = "2.10.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nixpkgs-review";
    rev = version;
    hash = "sha256-x41piT7peYV3sNMVYsqcjCU4u+PayZb05JIWBeWF7jw=";
  };

  nativeBuildInputs = [
    installShellFiles
    python3.pkgs.setuptools
  ] ++ lib.optionals withAutocomplete [
    python3.pkgs.argcomplete
  ];

  propagatedBuildInputs = [ python3.pkgs.argcomplete ];

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
  };
}
