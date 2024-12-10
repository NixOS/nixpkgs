{
  lib,
  stdenv,
  fetchFromGitHub,
  libgcrypt,
  pkg-config,
  glib,
  linuxHeaders ? stdenv.cc.libc.linuxHeaders,
  sqlite,
  util-linux,
  testers,
  duperemove,
}:

stdenv.mkDerivation rec {
  pname = "duperemove";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "markfasheh";
    repo = "duperemove";
    rev = "v${version}";
    hash = "sha256-iMv80UKktYOhNfVA3mW6kKv8TwLZaP6MQt24t3Rchk4=";
  };

  postPatch = ''
    substituteInPlace util.c --replace \
      "lscpu" "${lib.getBin util-linux}/bin/lscpu"
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libgcrypt
    glib
    linuxHeaders
    sqlite
    util-linux
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "VERSION=v${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = duperemove;
    command = "duperemove --version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "A simple tool for finding duplicated extents and submitting them for deduplication";
    homepage = "https://github.com/markfasheh/duperemove";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      bluescreen303
      thoughtpolice
    ];
    platforms = platforms.linux;
    mainProgram = "duperemove";
  };
}
