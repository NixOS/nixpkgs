{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "starruler2-data";
  version = "2022-08-30";

  src = fetchFromGitHub {
    owner = "OpenSRProject";
    repo = "OpenStarRuler-Data";
    rev = "681d87467f7e6bbdc3dddbbe4c6ab7a77fe0a781";
    hash = "sha256-MaGPbfSv3/j98seR+p2mVOf2zJ4A6Fc+W03SesgnPpU=";
  };

  installPhase = ''
    runHook preInstall

    dir="$out/share/games/starruler2"
    mkdir -p $dir
    mv data locales maps mods scripts credits.txt sr2.icns sr2.ico "$dir"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A massive-scale 4X/RTS game set in space -- data files";
    homepage = "https://github.com/OpenSRProject/OpenStarRuler-Data";
    license = with licenses; [mit cc-by-nc-20]; # Art assets are licensed as CC-BY-NC 2.0.
    maintainers = with maintainers; [justinlovinger];
    hydraPlatforms = [];
  };
}
