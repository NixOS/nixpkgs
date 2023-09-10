{ lib, stdenv, autoreconfHook, fetchFromGitHub, nix-update-script, fanotifySupport ? true }:

stdenv.mkDerivation (finalAttrs: {
  pname = "inotify-tools";
  version = "4.23.8.0";

  src = fetchFromGitHub {
    repo = "inotify-tools";
    owner = "inotify-tools";
    rev = finalAttrs.version;
    hash = "sha256-aD5jzUbDfB57wE1PSA3a+79owspSn7rcoRe5HsPDSXI=";
  };

  configureFlags = [
    (lib.enableFeature fanotifySupport "fanotify")
  ];

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
})
