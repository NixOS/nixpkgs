{ lib
, stdenvNoCC
, fetchFromGitHub
, sunwait
, wallutils
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sunpaper";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "hexive";
    repo = "sunpaper";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8s7SS79wCS0nRR7IpkshP5QWJqqKEeBu6EtFPDM+2cM=";
  };

  buildInputs = [
    wallutils
    sunwait
  ];

  postPatch = ''
    substituteInPlace sunpaper.sh \
      --replace "sunwait" "${sunwait}/bin/sunwait" \
      --replace "setwallpaper" "${wallutils}/bin/setwallpaper" \
      --replace '$HOME/sunpaper/images/' "$out/share/sunpaper/images/"
  '';

  installPhase = ''
    mkdir -p "$out/bin" "$out/share/sunpaper/images"
    cp sunpaper.sh $out/bin/sunpaper
    cp -R images $out/share/sunpaper/
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/sunpaper --help > /dev/null
  '';

  meta = {
    description = "A utility to change wallpaper based on local weather, sunrise and sunset times";
    homepage = "https://github.com/hexive/sunpaper";
    license = lib.licenses.asl20;
    mainProgram = "sunpaper";
    maintainers = with lib.maintainers; [ eclairevoyant jevy ];
    platforms = lib.platforms.linux;
  };
})
