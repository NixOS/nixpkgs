{ stdenvNoCC
, lib
, fetchFromGitHub
, makeWrapper
, xdpyinfo
, killall
, xwinwrap
}:

stdenvNoCC.mkDerivation {
  pname = "smart-wallpaper";
  version = "unstable-2022-09-01";

  src = fetchFromGitHub {
    owner = "Baitinq";
    repo = "smart-wallpaper";
    rev = "d175695d3485fb14144c1908eb3569b20caa6ba5";
    sha256 = "sha256-cFgvuntdKPzdQJ7xE2DIT+aNAazocIhM6BBbcQOlryU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 -t $out/bin smart-wallpaper
    wrapProgram $out/bin/smart-wallpaper \
      --prefix PATH : ${lib.makeBinPath [ xdpyinfo killall xwinwrap ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/Baitinq/smart-wallpaper";
    description = "A simple bash script that automatically changes your wallpaper depending on if its daytime or nighttime";
    license = licenses.bsd2;
    maintainers = with maintainers; [ baitinq ];
    platforms = platforms.linux;
  };
}
