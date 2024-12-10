{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  makeWrapper,
  xdpyinfo,
  killall,
  xwinwrap,
  swaybg,
  redshift,
}:

stdenvNoCC.mkDerivation {
  pname = "smart-wallpaper";
  version = "unstable-2022-09-15";

  src = fetchFromGitHub {
    owner = "Baitinq";
    repo = "smart-wallpaper";
    rev = "a23e6ed658342a405544ebe055ec1ac2fd464484";
    sha256 = "sha256-IymFjyfqNycTLalZBiqmjJP5U6AFefe9BSWn3Mpoz4c=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 -t $out/bin smart-wallpaper
    wrapProgram $out/bin/smart-wallpaper \
      --prefix PATH : ${
        lib.makeBinPath [
          xdpyinfo
          killall
          xwinwrap
          swaybg
          redshift
        ]
      }
  '';

  meta = with lib; {
    homepage = "https://github.com/Baitinq/smart-wallpaper";
    description = "A simple bash script that automatically changes your wallpaper depending on if its daytime or nighttime";
    license = licenses.bsd2;
    maintainers = with maintainers; [ baitinq ];
    platforms = platforms.linux;
    mainProgram = "smart-wallpaper";
  };
}
