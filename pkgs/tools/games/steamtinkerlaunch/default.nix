{ bash
, gawk
, git
, gnugrep
, fetchFromGitHub
, installShellFiles
, lib
, makeWrapper
, stdenv
, unixtools
, unzip
, wget
, xdotool
, xorg
, yad
}:

stdenv.mkDerivation rec {
  pname = "steamtinkerlaunch";
  version = "12.0";

  src = fetchFromGitHub {
    owner = "sonic2kk";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cEGERh0INc/xetQhALqc+lp/HNDoy3JdTZr/nHlthYc=";
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
      gnugrep
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
    homepage = "https://github.com/sonic2kk/steamtinkerlaunch";
    license = licenses.gpl3;
    maintainers = with maintainers; [ urandom ];
    platforms = lib.platforms.linux;
  };
}
