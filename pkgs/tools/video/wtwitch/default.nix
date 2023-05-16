{ bash
, coreutils-prefixed
, curl
, fetchFromGitHub
, gnused
, gnugrep
, installShellFiles
, jq
, lib
, makeWrapper
, mplayer
, mpv
<<<<<<< HEAD
=======
, ncurses
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, procps
, scdoc
, stdenv
, streamlink
<<<<<<< HEAD
=======
, sudo
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, vlc
}:

stdenv.mkDerivation rec {
  pname = "wtwitch";
<<<<<<< HEAD
  version = "2.6.3";
=======
  version = "2.6.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "krathalan";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-2YLBuxGwGkav3zB2qMqM6yRXf7ZLqgULoJV4s5p+hSw=";
=======
    hash = "sha256-kXUocEBxEyjWOEUPVO1oPWEu7MAVoD2r4Umi1LPNKjc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # hardcode SCRIPT_NAME because #150841
  postPatch = ''
    substituteInPlace src/wtwitch --replace 'readonly SCRIPT_NAME="''${0##*/}"' 'readonly SCRIPT_NAME="wtwitch"'
  '';

  buildPhase = ''
    scdoc < src/wtwitch.1.scd > wtwitch.1
  '';

  nativeBuildInputs = [ scdoc installShellFiles makeWrapper ];

  installPhase = ''
    installManPage wtwitch.1
    installShellCompletion --cmd wtwitch \
      --bash src/wtwitch-completion.bash \
      --zsh src/_wtwitch
    install -Dm755 src/wtwitch $out/bin/wtwitch
    wrapProgram $out/bin/wtwitch \
      --set-default LANG en_US.UTF-8 \
      --prefix PATH : ${lib.makeBinPath (lib.optionals stdenv.isLinux [ vlc ] ++ [
        bash
        coreutils-prefixed
        curl
        gnused
        gnugrep
        jq
        mplayer
        mpv
        procps
        streamlink
      ])}
  '';

  meta = with lib; {
    description = "Terminal user interface for Twitch";
    homepage = "https://github.com/krathalan/wtwitch";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ urandom ];
    platforms = platforms.all;
  };
}
