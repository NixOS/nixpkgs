{
  lib,
  stdenv,
  fetchFrom9Front,
  unstableGitUpdater,
  byacc,
  installShellFiles,
}:

stdenv.mkDerivation {
  pname = "rc-9front";
  version = "0-unstable-2022-11-01";

  src = fetchFrom9Front {
    domain = "shithub.us";
    owner = "cinap_lenrek";
    repo = "rc";
    rev = "69041639483e16392e3013491fcb382efd2b9374";
    hash = "sha256-xc+EfC4bc9ZA97jCQ6CGCzeLGf+Hx3/syl090/x4ew4=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    byacc
    installShellFiles
  ];
  enableParallelBuilding = true;
  patches = [ ./path.patch ];
  makeFlags = [ "PREFIX=$(out)" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin/ rc
    installManPage rc.1
    mkdir -p $out/lib
    install -m644 rcmain.unix $out/lib/rcmain

    runHook postInstall
  '';

  passthru = {
    shellPath = "/bin/rc";
    updateScript = unstableGitUpdater { shallowClone = false; };
  };

  meta = with lib; {
    description = "The 9front shell";
    longDescription = "unix port of 9front rc";
    homepage = "http://shithub.us/cinap_lenrek/rc/HEAD/info.html";
    license = licenses.mit;
    maintainers = with maintainers; [ moody ];
    mainProgram = "rc";
    platforms = platforms.all;
  };
}
