{ lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "gotools-unstable";
  version = "2021-01-13";
  rev = "8b4aab62c064010e8e875d2e5a8e63a96fefc87d";

  src = fetchgit {
    inherit rev;
    url = "https://go.googlesource.com/tools";
    sha256 = "1cmnm9fl2a6hiplj8s6x0l3czcw4xh3j3lvzbgccnp1l8kz8q2vm";
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

  vendorSha256 = "18qpjmmjpk322fvf81cafkpl3spv7hpdpymhympmld9isgzggfyz";

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

  excludedPackages = "\\("
    + lib.concatStringsSep "\\|" ([ "testdata" "vet" "cover" ])
    + "\\)";

  # Set GOTOOLDIR for derivations adding this to buildInputs
  postInstall = ''
    mkdir -p $out/nix-support
    substitute ${../../go-modules/tools/setup-hook.sh} $out/nix-support/setup-hook \
      --subst-var-by bin $out
  '';

  # Do not copy this without a good reason for enabling
  # In this case tools is heavily coupled with go itself and embeds paths.
  allowGoReference = true;
}
