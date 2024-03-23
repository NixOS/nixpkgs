{ lib
, python3
, fetchFromGitHub
, nix
, nix-prefetch-git
, nixpkgs-fmt
, nixpkgs-review
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nix-update";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = version;
    hash = "sha256-Nu9/mzL/notnR6Tvtj938Mo0TmYJutA2oJ6/rg2uZCo=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
  ];

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ nix nix-prefetch-git nixpkgs-fmt nixpkgs-review ])
  ];

  checkPhase = ''
    $out/bin/nix-update --help >/dev/null
  '';

  meta = with lib; {
    description = "Swiss-knife for updating nix packages";
    inherit (src.meta) homepage;
    changelog = "https://github.com/Mic92/nix-update/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda mic92 zowoq ];
    mainProgram = "nix-update";
    platforms = platforms.all;
  };
}
