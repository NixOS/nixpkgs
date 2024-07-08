{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "cue2pops";
  version = "unstable-2018-01-04";

  src = fetchFromGitHub {
    owner = "makefu";
    repo = "cue2pops-linux";
    rev = "541863adf23fdecde92eba5899f8d58586ca4551";
    sha256 = "05w84726g3k33rz0wwb9v77g7xh4cnhy9sxlpilf775nli9bynrk";
  };

  dontConfigure = true;

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    runHook preInstall
    install --directory --mode=755 $out/bin
    install --mode=755 cue2pops $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Convert CUE to ISO suitable to POPStarter";
    homepage = "https://github.com/makefu/cue2pops-linux";
    # Upstream license is unclear.
    # <https://github.com/ErikAndren/cue2pops-mac/issues/2#issuecomment-673983298>
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
    mainProgram = "cue2pops";
  };
}
