{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "acr";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "radareorg";
    repo = "acr";
    rev = version;
    hash = "sha256-ma4KhwGFlLCfRQvQ11OdyovgGbKQUBo6qVRrE7V2pNo=";
  };

  preConfigure = ''
    chmod +x ./autogen.sh && ./autogen.sh
  '';

  meta = with lib; {
    homepage = "https://github.com/radareorg/acr/";
    description = "Pure shell autoconf replacement";
    longDescription = ''
      ACR tries to replace autoconf functionality generating a full-compatible
      'configure' script (runtime flags). But using shell-script instead of
      m4. This means that ACR is faster, smaller and easy to use.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; all;
  };
}
