{ lib
, python3
, fetchFromGitHub

, bubblewrap
, cacert
, git
, nix

, withSandboxSupport ? false
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nixpkgs-review";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nixpkgs-review";
    rev = version;
    sha256 = "sha256-hGOcLrVPb+bSNA72ZfKE9Mjm2dr/qnuaCkjveHXPcws=";
  };

  makeWrapperArgs =
    let
      binPath = [ nix git ] ++ lib.optional withSandboxSupport bubblewrap;
    in
    [
      "--prefix PATH : ${lib.makeBinPath binPath}"
      "--set NIX_SSL_CERT_FILE ${cacert}/etc/ssl/certs/ca-bundle.crt"
      # we don't have any runtime deps but nix-review shells might inject unwanted dependencies
      "--unset PYTHONPATH"
    ];

  doCheck = false;

  meta = with lib; {
    description = "Review pull-requests on https://github.com/NixOS/nixpkgs";
    homepage = "https://github.com/Mic92/nixpkgs-review";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 SuperSandro2000 ];
  };
}
