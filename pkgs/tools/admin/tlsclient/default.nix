{ lib
, stdenv
, fetchFromSourcehut
, pkg-config
, openssl
, installShellFiles
}:

stdenv.mkDerivation rec {
  pname = "tlsclient";
  version = "1.5";

  src = fetchFromSourcehut {
    owner = "~moody";
    repo = "tlsclient";
    rev = "v${version}";
    hash = "sha256-9LKx9x5Kx7Mo4EL/b89Mdsdu8NqVYxohn98XnF+IWXs=";
  };

  strictDeps = true;
  enableParallelBuilding = true;
  nativeBuildInputs = [ pkg-config installShellFiles ];
  buildInputs = [ openssl ];

  makeFlags = [ "tlsclient" ];
  installPhase = ''
    install -Dm755 -t $out/bin tlsclient
    installManPage tlsclient.1
  '';

  meta = with lib; {
    description = "tlsclient command line utility";
    longDescription = "unix port of 9front's tlsclient(1) and rcpu(1)";
    homepage = "https://git.sr.ht/~moody/tlsclient";
    license = licenses.mit;
    maintainers = with maintainers; [ moody ];
    mainProgram = "tlsclient";
    platforms = platforms.all;
  };
}
