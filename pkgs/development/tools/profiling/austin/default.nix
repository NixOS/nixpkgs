{ stdenv, lib, fetchFromGitHub, fetchpatch, testers
, autoreconfHook, libbfd, libiberty, libunwind, zlib
, austin  # For testVersion
}:

stdenv.mkDerivation rec {
  pname = "austin";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "p403n1x87";
    repo = "austin";
    rev = "v${version}";
    hash = "sha256-R/LxGHapPjaaTbJh6/CxT49WvX3zg7u+mATQGZCEXtk=";
  };

  patches = [
    # https://github.com/P403n1x87/austin/issues/152
    (fetchpatch {
      url = "https://github.com/P403n1x87/austin/commit/1e26986ecd8981460af5b9bd6526d6560f9c16a0.patch";
      hash = "sha256-c+r1iLMXkPU3Mzn8qyZv0EDnTbrxZQrWGdRkebNTN/4=";
    })
  ];

  postPatch = ''
    # Allow linking with dynamic libraries. Replace "-l:libfoo.a" -> "-lfoo".
    sed -ri 's/-l:lib([^.]*).a/-l\1/g' configure.ac
  '';

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    libbfd
    libiberty
    libunwind
    zlib
  ];

  # TODO: run test suite in checkPhase. This requires currently unavailable
  # dependencies, and has some slightly annoying circular dependencies
  # (uses austin-python).

  passthru = {
    tests.austin-version = testers.testVersion {
      package = austin;
    };
    tests.austinp-version = testers.testVersion {
      package = austin;
      command = "austinp --version";
    };
  };

  meta = with lib; {
    description = "Python frame stack sampler for CPython";
    homepage = "https://github.com/p403n1x87/austin";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ delroth ];
  };
}
