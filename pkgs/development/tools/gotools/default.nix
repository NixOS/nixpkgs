{ stdenv, go, buildGoModule, fetchgit }:

buildGoModule rec {
  name = "gotools-unstable-${version}";
  version = "2019-05-24";
  rev = "2c0ae70061356820330c96810d9483beb9a6da8e";

  src = fetchgit {
    inherit rev;
    url = "https://go.googlesource.com/tools";
    sha256 = "1lsi2ssxajclj3bciz2a41v1vjv768ja3v6wnbyhxy8xphwkp4fk";
  };

  modSha256 = "0cm7fwb1k5hvbhh86kagzsw5vwgkr6dr7glhbjxg5xaahlhx2w5w";

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
