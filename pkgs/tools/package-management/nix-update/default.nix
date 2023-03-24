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
  version = "0.16.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = version;
    hash = "sha256-4Hrumb4c0861Aorzfk0eM3++XiWkGopnMuIdb+MTKlo=";
  };

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
    platforms = platforms.all;
  };
}
