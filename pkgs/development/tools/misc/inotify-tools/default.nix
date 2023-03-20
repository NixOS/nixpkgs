{ lib, stdenv, autoreconfHook, fetchFromGitHub, nix-update-script }:

stdenv.mkDerivation rec {
  pname = "inotify-tools";
  version = "3.22.6.0";

  src = fetchFromGitHub {
    repo = "inotify-tools";
    owner = "inotify-tools";
    rev = version;
    sha256 = "sha256-EYWVSgwoMjAlc/V5kv+2jfxEqWVW/lEoIxVd+ctEMsk=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://github.com/inotify-tools/inotify-tools/wiki";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ marcweber pSub shamilton ];
    platforms = platforms.linux;
  };
}
