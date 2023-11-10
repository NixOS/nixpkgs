{ lib
, stdenv
, fetchFromGitHub
, fetchpatch2
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
  version = "0.13";

  src = fetchFromGitHub {
    owner = "markfasheh";
    repo = "duperemove";
    rev = "v${version}";
    hash = "sha256-D3+p8XgokKIHEwZnvOkn7cionVH1gsypcURF+PBpugY=";
  };

  patches = [
    # Use variable instead of hardcoding pkg-config
    # https://github.com/markfasheh/duperemove/pull/315
    (fetchpatch2 {
      url = "https://github.com/markfasheh/duperemove/commit/0e1c62d79a9a79d7bb3e80f1bd528dbf7cb75e22.patch";
      hash = "sha256-YMMu6LCkBlipEJALukQMwIMcjQEAG5pjGEGeTW9OEJk=";
    })
  ];

  postPatch = ''
    substituteInPlace util.c --replace \
      "lscpu" "${lib.getBin util-linux}/bin/lscpu"
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libgcrypt glib linuxHeaders sqlite ];

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
    license = licenses.gpl2;
    maintainers = with maintainers; [ bluescreen303 thoughtpolice ];
    platforms = platforms.linux;
  };
}
