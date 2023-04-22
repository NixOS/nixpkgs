{ lib
, python3
, fetchFromGitHub

, bubblewrap
, nix-output-monitor
, cacert
, git
, nix

, withSandboxSupport ? false
, withNom ? false
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nixpkgs-review";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nixpkgs-review";
    rev = version;
    sha256 = "sha256-9fdoTKaYfqsAXysRwgLq44UrmOGlr5rjF5Ge93PcHDk=";
  };

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

  meta = with lib; {
    description = "Review pull-requests on https://github.com/NixOS/nixpkgs";
    homepage = "https://github.com/Mic92/nixpkgs-review";
    changelog = "https://github.com/Mic92/nixpkgs-review/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda mic92 SuperSandro2000 ];
  };
}
