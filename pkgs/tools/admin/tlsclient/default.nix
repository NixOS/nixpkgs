{ lib
, stdenv
, fetchFromSourcehut
, pkg-config
, openssl
, gitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tlsclient";
  version = "1.6.4";

  src = fetchFromSourcehut {
    owner = "~moody";
    repo = "tlsclient";
    rev = "v${finalAttrs.version}";
    hash = "sha256-36fhY9kO6tPUuRkpk3Jv9oBRYX/SnmdZg0Rzt/A6MQE=";
  };

  strictDeps = true;
  enableParallelBuilding = true;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  buildFlags = [ "tlsclient" ];
  installFlags = [ "PREFIX=$(out)" ];
  installTargets = "tlsclient.install";

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "tlsclient command line utility";
    longDescription = "unix port of 9front's tlsclient(1) and rcpu(1)";
    homepage = "https://git.sr.ht/~moody/tlsclient";
    license = licenses.mit;
    maintainers = with maintainers; [ moody ];
    mainProgram = "tlsclient";
    platforms = platforms.all;
  };
})
