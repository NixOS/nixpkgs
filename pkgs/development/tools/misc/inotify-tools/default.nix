<<<<<<< HEAD
{ lib, stdenv, autoreconfHook, fetchFromGitHub, nix-update-script, fanotifySupport ? true }:

stdenv.mkDerivation (finalAttrs: {
  pname = "inotify-tools";
  version = "4.23.8.0";
=======
{ lib, stdenv, autoreconfHook, fetchFromGitHub, nix-update-script }:

stdenv.mkDerivation rec {
  pname = "inotify-tools";
  version = "3.22.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    repo = "inotify-tools";
    owner = "inotify-tools";
<<<<<<< HEAD
    rev = finalAttrs.version;
    hash = "sha256-aD5jzUbDfB57wE1PSA3a+79owspSn7rcoRe5HsPDSXI=";
  };

  configureFlags = [
    (lib.enableFeature fanotifySupport "fanotify")
  ];

=======
    rev = version;
    sha256 = "sha256-EYWVSgwoMjAlc/V5kv+2jfxEqWVW/lEoIxVd+ctEMsk=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
