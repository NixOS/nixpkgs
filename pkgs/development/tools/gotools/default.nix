{ stdenv, go, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "gotools-unstable-${version}";
  version = "2019-03-05";
  rev = "00c44ba9c14f88ffdd4fb5bfae57fe8dd6d6afb1";

  goPackagePath = "golang.org/x/tools";
  goPackageAliases = [ "code.google.com/p/go.tools" ];

  src = fetchgit {
    inherit rev;
    url = "https://go.googlesource.com/tools";
    sha256 = "04rpdi52j26szx5kiyfmwad1sg7lfplxrkbwkr3b1kfafh1whgw5";
  };

  goDeps = ./deps.nix;

  preConfigure = ''
    # Make the builtin tools available here
    mkdir -p $bin/bin
    eval $(go env | grep GOTOOLDIR)
    find $GOTOOLDIR -type f | while read x; do
      ln -sv "$x" "$bin/bin"
    done
    export GOTOOLDIR=$bin/bin
  '';

  excludedPackages = "\\("
    + stdenv.lib.concatStringsSep "\\|" ([ "testdata" ] ++ stdenv.lib.optionals (stdenv.lib.versionAtLeast go.meta.branch "1.5") [ "vet" "cover" ])
    + "\\)";

  # Do not copy this without a good reason for enabling
  # In this case tools is heavily coupled with go itself and embeds paths.
  allowGoReference = true;

  # Set GOTOOLDIR for derivations adding this to buildInputs
  postInstall = ''
    mkdir -p $bin/nix-support
    substituteAll ${../../go-modules/tools/setup-hook.sh} $bin/nix-support/setup-hook.tmp
    cat $bin/nix-support/setup-hook.tmp >> $bin/nix-support/setup-hook
    rm $bin/nix-support/setup-hook.tmp
  '';
}
