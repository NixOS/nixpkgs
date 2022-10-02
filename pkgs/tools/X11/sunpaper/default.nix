{ lib
, stdenvNoCC
, fetchFromGitHub
, sunwait
, wallutils
, rPackages
}:

stdenvNoCC.mkDerivation rec {
  pname = "sunpaper";
  version = "unstable-2022-04-01";

  src = fetchFromGitHub {
    owner = "hexive";
    repo = "sunpaper";
    rev = "8d518dfddb5e80215ef3b884ff009df1d4bb74c2";
    sha256 = "sCG7igD2ZwfHoRpR3Kw7dAded4hG2RbMLR/9nH+nZh8=";
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

  meta = with lib; {
    description = "A utility to change wallpaper based on local weather, sunrise and sunset times";
    homepage = "https://github.com/hexive/sunpaper";
    license = lib.licenses.unfree;
    maintainers = with maintainers; [ jevy ];
    platforms = platforms.unix;
  };
}
