{ lib
, stdenv
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, fetchFromGitHub
, sfml
, anttweakbar
, glm
, eigen
, glew
, cmake
}:
stdenv.mkDerivation rec {
  pname = "marble-marcher-ce";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "WAUthethird";
    repo = "Marble-Marcher-Community-Edition";
    rev = version;
    hash = "sha256-m5i/Q4k5S4wcojHqMYS7e1W/Ph7q/95j3oOK2xbrHSk=";
  };

  buildInputs = [ sfml anttweakbar glm eigen glew ];
  nativeBuildInputs = [ cmake makeWrapper copyDesktopItems ];
  installFlags = [ "DESTDIR=$(out)" ];

  prePatch = ''
    # the path /home/MMCE is always added to DESTDIR
    # we change this to a more sensible path
    # see https://github.com/WAUthethird/Marble-Marcher-Community-Edition/issues/23
    substituteInPlace CMakeLists.txt \
      --replace '/home/MMCE' '/share/MMCE'
  '';

  postInstall = ''
    mkdir $out/bin
    mkdir -p $out/share/icons/
    # The executable has to be run from the same directory the assets are in
    makeWrapper $out/share/MMCE/MarbleMarcher $out/bin/${pname} --chdir $out/share/MMCE
    ln -s $out/share/MMCE/images/MarbleMarcher.png $out/share/icons/${pname}.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
      desktopName = pname;
      comment = meta.description;
      categories = [ "Game" ];
    })
  ];

  meta = with lib; {
    description = "A community-developed version of the original Marble Marcher - a fractal physics game";
    mainProgram = "marble-marcher-ce";
    homepage = "https://michaelmoroz.itch.io/mmce";
    license = with licenses; [
      gpl2Plus # Code
      cc-by-30 # Assets
      ofl # Fonts
    ];
    maintainers = with maintainers; [ rampoina ];
    platforms = platforms.linux;
  };
}
