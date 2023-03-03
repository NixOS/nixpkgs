{ lib
, stdenvNoCC
, fetchFromGitHub
, sunwait
, wallutils
, rPackages
}:

stdenvNoCC.mkDerivation rec {
  pname = "sunpaper";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "hexive";
    repo = "sunpaper";
    rev = "v${version}";
    sha256 = "sha256-8s7SS79wCS0nRR7IpkshP5QWJqqKEeBu6EtFPDM+2cM=";
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
