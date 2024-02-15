{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gotools";
  version = "0.16.1";

  # using GitHub instead of https://go.googlesource.com/tools because Gitiles UI is to basic to browse
  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "v${version}";
    hash = "sha256-qFDi+d+2OuI+mMBceZiN+kJ0gPcfgXXRDrDDwqKeDOM=";
  };

  postPatch = ''
    # The gopls folder contains a Go submodule which causes a build failure
    # and lives in its own package named gopls.
    rm -r gopls
    # getgo is an experimental go installer which adds generic named server and client binaries to $out/bin
    rm -r cmd/getgo
  '';

  vendorHash = "sha256-oOBdh4mK3x9HbxD00EDKLjFgd/4NQRlQXrnCigGOwLg=";

  doCheck = false;

  # Set GOTOOLDIR for derivations adding this to buildInputs
  postInstall = ''
    mkdir -p $out/nix-support
    substitute ${./setup-hook.sh} $out/nix-support/setup-hook \
      --subst-var-by bin $out
  '';

  meta = with lib; {
    description = "Additional tools for Go development";
    longDescription = ''
      This package contains tools like: godoc, goimports, callgraph, digraph, stringer or toolstash.
    '';
    homepage = "https://go.googlesource.com/tools";
    license = licenses.bsd3;
    maintainers = with maintainers; [ danderson SuperSandro2000 ];
  };
}
