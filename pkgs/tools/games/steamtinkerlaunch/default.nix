{ bash
, fetchFromGitHub
, gawk
, git
, lib
, makeWrapper
, procps
, stdenvNoCC
, unixtools
, unzip
, wget
, xdotool
, xorg
, yad
}:

stdenvNoCC.mkDerivation {
  pname = "steamtinkerlaunch";
  version = "12.12-unstable-2024-05-03";

  src = fetchFromGitHub {
    owner = "sonic2kk";
    repo = "steamtinkerlaunch";
    rev = "59b421b2f3686120a076909a4a158824cd4ef05e";
    hash = "sha256-CGtSGAm+52t2zFsPJEsm76w+FEHhbOd9NYuerGa31tc=";
  };

  # hardcode PROGCMD because #150841
  postPatch = ''
    substituteInPlace steamtinkerlaunch --replace 'PROGCMD="''${0##*/}"' 'PROGCMD="steamtinkerlaunch"'
  '';

  nativeBuildInputs = [ makeWrapper ];

  installFlags = [ "PREFIX=\${out}" ];

  postInstall = ''
    wrapProgram $out/bin/steamtinkerlaunch --prefix PATH : ${lib.makeBinPath [
      bash
      gawk
      git
      procps
      unixtools.xxd
      unzip
      wget
      xdotool
      xorg.xprop
      xorg.xrandr
      xorg.xwininfo
      yad
    ]}
  '';

  meta = with lib; {
    description = "Linux wrapper tool for use with the Steam client for custom launch options and 3rd party programs";
    mainProgram = "steamtinkerlaunch";
    homepage = "https://github.com/sonic2kk/steamtinkerlaunch";
    license = licenses.gpl3;
    maintainers = with maintainers; [ urandom surfaceflinger ];
    platforms = lib.platforms.linux;
  };
}
