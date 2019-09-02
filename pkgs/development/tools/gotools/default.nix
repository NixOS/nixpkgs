{ stdenv, go, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "gotools-unstable";
  version = "2019-07-06";
  rev = "72ffa07ba3db8d09f5215feec0f89464f3028f8e";

  src = fetchgit {
    inherit rev;
    url = "https://go.googlesource.com/tools";
    sha256 = "0c0s5aiwj807vxfzwrah32spwq8cnxvy0j117i5cbsqw2df80pgv";
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

  modSha256 = "16nkrpki9fnxsrxxxs9ljz49plcz393z0sqq2knkk30pmncpwd3q";

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
