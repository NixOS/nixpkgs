{
  lib,
  stdenv,
  fetchFromGitHub,
  wl-clipboard,
  bash,
}:

stdenv.mkDerivation rec {
  pname = "wl-clipboard-x11";
  version = "5";

  src = fetchFromGitHub {
    owner = "brunelli";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-i+oF1Mu72O5WPTWzqsvo4l2CERWWp4Jq/U0DffPZ8vg=";
  };

  strictDeps = true;
  buildInputs = [ bash ];
  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postPatch = ''
    substituteInPlace src/wl-clipboard-x11 \
      --replace '$(command -v wl-copy)' ${wl-clipboard}/bin/wl-copy \
      --replace '$(command -v wl-paste)' ${wl-clipboard}/bin/wl-paste
  '';

  meta = with lib; {
    description = "A wrapper to use wl-clipboard as a drop-in replacement for X11 clipboard tools";
    homepage = "https://github.com/brunelli/wl-clipboard-x11";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ artturin ];
    mainProgram = "xclip";
    platforms = platforms.linux;
  };
}
