{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  makeWrapper,
  perl,
  ffmpeg-full,
  imagemagick,
  xdpyinfo,
  xprop,
  xrectsel,
  xwininfo,
}:

stdenv.mkDerivation rec {
  pname = "ffcast";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "ropery";
    repo = "FFcast";
    rev = version;
    sha256 = "sha256-kxqwDGEguFTFHkQzXctXqxslt0+bYnfUdQ8C/8+eTXo=";
  };

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
    perl # for pod2man
  ];

  configureFlags = [ "--disable-xrectsel" ];

  postInstall =
    let
      binPath = lib.makeBinPath [
        ffmpeg-full
        imagemagick
        xdpyinfo
        xprop
        xrectsel
        xwininfo
      ];
    in
    ''
      wrapProgram $out/bin/ffcast --prefix PATH : ${binPath}
    '';

  meta = with lib; {
    description = "Run commands on rectangular screen regions";
    homepage = "https://github.com/ropery/FFcast";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux;
    mainProgram = "ffcast";
  };
}
