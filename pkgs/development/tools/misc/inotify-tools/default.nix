{ lib, stdenv, autoreconfHook, fetchFromGitHub, nix-update-script }:

stdenv.mkDerivation rec {
  pname = "inotify-tools";
  version = "3.22.1.0";

  src = fetchFromGitHub {
    repo = "inotify-tools";
    owner = "inotify-tools";
    rev = version;
    sha256 = "sha256-I0kr+wFUWnovH9MXVsGaCBtp4+RnnMWD7sPecI3xz+Y=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    homepage = "https://github.com/inotify-tools/inotify-tools/wiki";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ marcweber pSub shamilton ];
    platforms = platforms.linux;
  };
}
