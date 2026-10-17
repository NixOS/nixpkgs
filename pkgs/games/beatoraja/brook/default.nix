{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "brook";
  version = "1.0.3";

  src = fetchzip {
    url = "https://drive.usercontent.google.com/download?export=download&confirm=t&id=1ei0w7_gMkZ7TU9q79WkQ5RPnTIbhWbOk";
    extension = "zip";
    hash = "sha256-HljuIvleDY+NB28ukzKWmW2fWX8jgarFFejvY4GNUEE=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/beatoraja/skin/isocosa_brook
    cp -r * $out/share/beatoraja/skin/isocosa_brook

    runHook postInstall
  '';

  meta = {
    description = "Complete and Full HD skin written in JSON for beatoraja";
    homepage = "https://www.gaftalk.com/blog/items/brook-beatoraja-skin/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = lib.platforms.unix;
  };
})
