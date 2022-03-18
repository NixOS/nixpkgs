{ lib, fetchzip, callPackage_i686, stdenv }:

callPackage_i686 ./. {
  patchPath = fetchzip {
    url = "https://github.com/milesthenerd/AM2R-Multitroid/releases/download/v1.4.2/Multitroid_1.4.2_lin.zip";
    sha256 = "sha256-cgF/JvzmxQebjlooWAG0z8PHexLtZrwDArlYov6xq+4=";
    stripRoot = false;
  };
  pname = "am2r-multitroid";
  desktopName = "AM2R Multitroid";
  version = "1.4.2";
  meta = with lib; {
    description = "Multiplayer mod for AM2R";
    homepage = "https://github.com/milesthenerd/AM2R-Multitroid";
    # Maybe wrong, I don't know whater the same link applies (https://github.com/AM2R-Community-Developers/AM2R-Autopatcher-Linux/blob/master/LICENSE)
    # Maybe this is the one that applies: https://github.com/milesthenerd/AM2R-Multitroid/blob/main/LICENSE
    license = licenses.gpl3;
    maintainers = [ maintainers.martfont ];
    platforms = platforms.linux;
    hydraPlatforms = [];
    # It can execute, but for reason it doesn't detect game.unx
    # if you are not on the same folder (it didn't do this before...).
    broken = true; 
  };
}

/*stdenv.mkDerivation {
  pname = "am2r-multitroid-server";
  version = "1.4.2";
  src = fetchzip {
    url = "https://github.com/milesthenerd/AM2R-Server/releases/download/v1.4.2/AM2R_Server_1.4.2_lin.zip";
    sha256 = "c8376740d89130ea2df79064f484a181e58e9f798e5effe9d989aa45103d3afe";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out
    cp -r $src $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/milesthenerd/AM2R-Server";
    license = licenses.mit;
    maintainers = [ maintainers.martfont ];
    platforms = platforms.linux;
  };
}*/