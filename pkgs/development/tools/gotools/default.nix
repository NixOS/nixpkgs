{ stdenv, go, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "gotools-unstable";
  version = "2020-04-21";
  rev = "72e4a01eba4315301fd9ce00c8c2f492580ded8a";

  src = fetchgit {
    inherit rev;
    url = "https://go.googlesource.com/tools";
    sha256 = "0a8c7j4w784w441j3j3bh640vy1g6g214641qv485wyi0xj49anf";
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

  vendorSha256 = "0pplmqxrnc8qnr5708igx4dm7rb0hicvhg6lh5hj8zkx38nb19s0";

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
