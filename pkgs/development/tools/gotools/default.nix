{ lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "gotools";
  version = "0.1.10";

  src = fetchgit {
    rev = "v${version}";
    url = "https://go.googlesource.com/tools";
    sha256 = "sha256-r71+//VhayW18uvMl/ls/8KYNbZ7uDZw3SWoqPL3Xqk=";
  };

  # The gopls folder contains a Go submodule which causes a build failure.
  # Given that, we can't have the gopls binary be part of the gotools
  # derivation.
  #
  # The attribute "gopls" provides the gopls binary.
  #
  # Related
  #
  # * https://github.com/NixOS/nixpkgs/pull/85868
  # * https://github.com/NixOS/nixpkgs/issues/88716
  postPatch = ''
    rm -rf gopls
  '';

  vendorSha256 = "sha256-UJIXG8WKzazNTXoqEFlT/umC40F6z2Q5I8RfxnMbsPM=";

  doCheck = false;

  postConfigure = ''
    # Make the builtin tools available here
    mkdir -p $out/bin
    eval $(go env | grep GOTOOLDIR)
    find $GOTOOLDIR -type f | while read x; do
      ln -sv "$x" "$out/bin"
    done
    export GOTOOLDIR=$out/bin
  '';

  excludedPackages = [ "vet" "cover" ];

  # Set GOTOOLDIR for derivations adding this to buildInputs
  postInstall = ''
    mkdir -p $out/nix-support
    substitute ${./setup-hook.sh} $out/nix-support/setup-hook \
      --subst-var-by bin $out
  '';

  # Do not copy this without a good reason for enabling
  # In this case tools is heavily coupled with go itself and embeds paths.
  allowGoReference = true;

  meta = with lib; {
    description = "Additional tools for Go development";
    homepage = "http://go.googlesource.com/tools";
    license = licenses.bsd3;
    maintainers = with maintainers; [ danderson ];
  };
}
