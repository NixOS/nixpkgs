{ stdenv, go, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "gotools-unstable";
  version = "2020-10-27";
  rev = "eafbe7b904eb2418efc832e36ac634dc09084f10";

  src = fetchgit {
    inherit rev;
    url = "https://go.googlesource.com/tools";
    sha256 = "0884znfbm44f4ddjkm0g7qg2a257kwzv1ismd2m225f3c69n3mdg";
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
    + stdenv.lib.concatStringsSep "\\|" ([ "testdata" ] ++ stdenv.lib.optionals (stdenv.lib.versionAtLeast go.meta.branch "1.5") [ "vet" "cover" ])
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
