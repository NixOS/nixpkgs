{ lib
, stdenv
, fetchFromGitLab
, cmake
, libsodium
, json_c
, ncurses
, libxml2
, jq
}:

stdenv.mkDerivation rec {
  pname = "spectre-cli";
  version = "unstable-2022-02-05";

  src = fetchFromGitLab {
    owner = "spectre.app";
    repo = "cli";
    rev = "a5e7aab28f44b90e5bd1204126339a81f64942d2";
    sha256 = "1hp4l1rhg7bzgx0hcai08rvcy6l9645sfngy2cr96l1bpypcld5i";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    libxml2
    jq
  ];

  buildInputs = [
    libsodium
    json_c
    ncurses
  ];

  cmakeFlags = [
    "-DBUILD_SPECTRE_TESTS=ON"
  ];

  preConfigure = ''
   echo "${version}" > VERSION

    # The default buildPhase wants to create a ´build´ dir so we rename the build script to stop conflicts.
    mv build build.sh
  '';

  # Some tests are expected to fail on ARM64
  # See: https://gitlab.com/spectre.app/cli/-/issues/27#note_962950844
  doCheck = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);

  checkPhase = ''
    mv ../spectre-cli-tests ../spectre_tests.xml ./
    patchShebangs spectre-cli-tests
    export HOME=$(mktemp -d)

    ./spectre-tests
    ./spectre-cli-tests
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv spectre $out/bin
  '';

  meta = with lib; {
    description = "Stateless cryptographic identity algorithm";
    homepage = "https://spectre.app";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ emmabastas ];
    mainProgram = "spectre";
    platforms = platforms.all;
  };
}
