{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gotools";
  version = "0.18.0";

  # using GitHub instead of https://go.googlesource.com/tools because Gitiles UI is to basic to browse
  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "v${version}";
    hash = "sha256-sOT98DdLYtPXovpcX020BbLSH99ByJSaVQeM10IcKG4=";
  };

  postPatch = ''
    # The gopls folder contains a Go submodule which causes a build failure
    # and lives in its own package named gopls.
    rm -r gopls
    # getgo is an experimental go installer which adds generic named server and client binaries to $out/bin
    rm -r cmd/getgo
  '';

  vendorHash = "sha256-gGAEl3yabXy1qbuBJyrpD+TRrKr56cZEOiSaBoBsYc8=";

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
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
