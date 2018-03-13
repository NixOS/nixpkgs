{ lib, stdenv, hostPlatform, fetchurl }:

# Building from source does not appear to work, binary distribution only :(

let
  inherit (lib.attrsets) mapAttrs;

  version = "0.3.1";

  dl = platform:
    "https://github.com/gravitational/teleconsole/releases/download/${version}/teleconsole-v${version}-${platform}.tar.gz";

  binaries = mapAttrs (platform: sha1: { url = dl platform; inherit sha1; } )
    { darwin-amd64  = "51af9b9656d200aef97c509db842e11b1c46ee5f";
      freebsd-amd64 = "189146199854cab9f77fc8940fa2775d4fac274f";
      linux-amd64   = "cfc5082e900e545b3ab1d5b4048cb9660e544c2f";
      linux-arm     = "44e0b60e05989254d0c5da638d3f6cb7cf263dba";
    };

  src = fetchurl ( with hostPlatform;
    if is64bit && isDarwin  then binaries.darwin-amd64 else
    if is64bit && isFreeBSD then binaries.freebsd-amd64 else
    if is64bit && isLinux   then binaries.linux-amd64 else
    if isArm   && isLinux   then binaries.linux-arm else
    abort "unsupported platform" );
in

stdenv.mkDerivation rec {
  inherit version src;

  name = "teleconsole-v${version}";

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    cp teleconsole $out/bin
  '';

  preFixup = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/bin/*
  '';

  meta = with lib; {
    homepage = "https://www.teleconsole.com/";
    description = "Share your terminal session with people you trust";
    license = licenses.asl20;
    platforms = with platforms; linux ++ darwin ++ freebsd;
    maintainers = [ maintainers.kimburgess ];
  };
}
