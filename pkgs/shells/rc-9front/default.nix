{
lib
, stdenv
, fetchgit
, byacc
, installShellFiles
}:

stdenv.mkDerivation rec {
  pname = "rc-9front";
  version = "unstable-2022-11-01";

  src = fetchgit {
    url = "git://shithub.us/cinap_lenrek/rc";
    rev = "69041639483e16392e3013491fcb382efd2b9374";
    hash = "sha256-xc+EfC4bc9ZA97jCQ6CGCzeLGf+Hx3/syl090/x4ew4=";
  };

  strictDeps = true;
  nativeBuildInputs = [ byacc installShellFiles ];
  patches = [ ./path.patch ];

  buildPhase = ''
    make PREFIX=$out
  '';

  installPhase = ''
    install -Dm755 -t $out/bin/ rc
    installManPage rc.1
    mkdir -p $out/lib
    install -m644 rcmain.unix $out/lib/rcmain
  '';

  passthru.shellPath = "/bin/rc";

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
