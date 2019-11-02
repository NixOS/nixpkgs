{ stdenv, go, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "gotools-unstable";
  version = "2019-09-05";
  rev = "6b3d1c9ba8bf7ce410f6b490852ec54953383362";

  src = fetchgit {
    inherit rev;
    url = "https://go.googlesource.com/tools";
    sha256 = "0a2xjx9hqkash7fd2qv9hd93wcqdbfrmsdzjd91dwvnk48j61daf";
  };

  # Build of golang.org/x/tools/gopls fails with:
  #   can't load package: package golang.org/x/tools/gopls: unknown import path "golang.org/x/tools/gopls": cannot find module providing package golang.org/x/tools/gopls
  # That is most probably caused by golang.org/x/tools/gopls containing a separate Go module.
  # In order to fix this, we simply remove the module.
  # Note that build of golang.org/x/tools/cmd/gopls provides identical binary as golang.org/x/tools/gopls.
  # See https://github.com/NixOS/nixpkgs/pull/64335.
  postPatch = ''
    rm -rf gopls
  '';

  modSha256 = "16cfzmfr9jv8wz0whl433xdm614dk63fzjxv6l1xvkagjmki49iy";

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
    substituteAll ${../../go-modules/tools/setup-hook.sh} $out/nix-support/setup-hook.tmp
    cat $out/nix-support/setup-hook.tmp >> $out/nix-support/setup-hook
    rm $out/nix-support/setup-hook.tmp
  '';

  # Do not copy this without a good reason for enabling
  # In this case tools is heavily coupled with go itself and embeds paths.
  allowGoReference = true;
}
