{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  bison,
  flex,
  perl, # for pod2man
  pkg-config,
  readline,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "augeas";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "hercules-team";
    repo = "augeas";
    rev = "release-${version}";
    fetchSubmodules = true;
    hash = "sha256-U5tm3LDUeI/idHtL2Zy33BigkyvHunXPjToDC59G9VE=";
  };

  patches = [
    # already have the submodules so don't fail when .git doesn't exist.
    ./bootstrap.diff
  ];

  postPatch = ''
    ./bootstrap --gnulib-srcdir=.gnulib
  '';

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    perl
    pkg-config
  ];

  buildInputs = [
    readline
    libxml2
  ];

  enableParallelBuilding = true;

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    patchShebangs --build gnulib/tests tests
    make -j $NIX_BUILD_CORES check
    runHook postCheck
  '';

  outputs = [
    "out"
    "dev"
  ];

  meta = with lib; {
    description = "Configuration editing tool";
    license = licenses.lgpl21Only;
    homepage = "https://augeas.net/";
    changelog = "https://github.com/hercules-team/augeas/releases/tag/release-${version}";
    mainProgram = "augtool";
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
