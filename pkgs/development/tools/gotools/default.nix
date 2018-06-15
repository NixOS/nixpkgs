{ stdenv, lib, go, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "gotools-${version}";
  version = "20170807-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "5d2fd3ccab986d52112bf301d47a819783339d0e";

  goPackagePath = "golang.org/x/tools";
  goPackageAliases = [ "code.google.com/p/go.tools" ];

  src = fetchgit {
    inherit rev;
    url = "https://go.googlesource.com/tools";
    sha256 = "0r3fp7na6pg0bc5xfycjvv951f0vma1qfnpw5zy6l75yxm5r47kn";
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
