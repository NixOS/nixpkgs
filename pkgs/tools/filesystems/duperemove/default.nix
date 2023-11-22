{ lib
, stdenv
, fetchFromGitHub
, libgcrypt
, pkg-config
, glib
, linuxHeaders ? stdenv.cc.libc.linuxHeaders
, sqlite
, util-linux
, testers
, duperemove
}:

stdenv.mkDerivation rec {
  pname = "duperemove";
  version = "0.14";

  src = fetchFromGitHub {
    owner = "markfasheh";
    repo = "duperemove";
    rev = "v${version}";
    hash = "sha256-hYBD5XFjM2AEsQm7yKEHkfjwLZmXTxkY/6S3hs1uBPw=";
  };

  postPatch = ''
    substituteInPlace util.c --replace \
      "lscpu" "${lib.getBin util-linux}/bin/lscpu"
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libgcrypt glib linuxHeaders sqlite util-linux ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "VERSION=v${version}"
    "CFLAGS=-Wno-error=format-security"
  ];

  passthru.tests.version = testers.testVersion {
    package = duperemove;
    command = "duperemove --version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "A simple tool for finding duplicated extents and submitting them for deduplication";
    homepage = "https://github.com/markfasheh/duperemove";
    license = licenses.gpl2;
    maintainers = with maintainers; [ bluescreen303 thoughtpolice ];
    platforms = platforms.linux;
    mainProgram = "duperemove";
  };
}
