{
  stdenv, lib, fetchurl, fetchFromGitHub,
  nim, cmake, which, writeScriptBin,
  # Options: wakunode1, wakunode2, wakubridge
  makeTargets ? [ "wakunode2" ],
  # WARNING: CPU optmizations that make binary not portable.
  nativeBuild ? false
}:

assert nim.version == "1.6.12";

stdenv.mkDerivation rec {
  pname = "nwaku";
  version = "0.16.0";
  commit = "03f0de36";
  name = "${pname}-${version}-${commit}";

  src = fetchFromGitHub {
    owner = "waku-org";
    repo = "nwaku";
    rev = "v${version}";
    sha256 = "sha256-yj+wNqo25BrLm+RjHelbnhg/Cq+m8Sayk+ycDw+Tksk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ nim ]
    ++ lib.optionals stdenv.isDarwin [ cmake ];

  buildInputs = let
    # Fix for Nim compiler calling 'git rev-parse' and 'lsb_release'.
    fakeGit = writeScriptBin "git" "echo $commit";
    fakeLsbRelease = writeScriptBin "lsb_release" "echo nix";
  in [ fakeGit fakeLsbRelease which ];

  enableParallelBuilding = true;
  dontUseCmakeConfigure = true;

  # Avoid make calling 'git describe'.
  GIT_VERSION = "v${version}";

  NIMFLAGS = lib.optionalString (!nativeBuild) " -d:disableMarchNative";

  # Use available Nim and avoid recompiling Nim for every build.
  makeFlags = makeTargets ++ [ "USE_SYSTEM_NIM=1" ];

  # Generate vendor/.nimble contents with correct paths.
  configurePhase = ''
    runHook preConfigure
    export HOME=$PWD
    export PWD_CMD=$(which pwd)
    export EXCLUDED_NIM_PACKAGES=""
    export NIMBLE_LINK_SCRIPT=$PWD/vendor/nimbus-build-system/scripts/create_nimble_link.sh
    export NIMBLE_DIR=$PWD/vendor/.nimble
    patchShebangs vendor/nimbus-build-system/scripts
    for dep_dir in $(find vendor -type d -maxdepth 1); do
        pushd "$dep_dir"
        $NIMBLE_LINK_SCRIPT "$dep_dir"
        popd
    done
    runHook postConfigure
  '';

  # Nwaku uses it's own specific Nim version bound as a Git submodule.
  #preBuild = ''
  #  # Necessary for nim cache creation
  #  export HOME=$PWD
  #  make -j$NIX_BUILD_CORES build-nim
  #  export PATH="$PWD/vendor/nimbus-build-system/vendor/Nim/bin:$PATH"
  #'';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp build/* $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://waku.org/";
    downloadPage = "https://github.com/waku-org/nwaku/releases";
    changelog = "https://github.com/waku-org/nwaku/blob/master/CHANGELOG.md";
    description = "Waku is the communication layer for Web3. Decentralized communication that scales.";
    longDescription = ''
      Waku is a suite of privacy-preserving, peer-to-peer messaging protocols.
      It removes centralized third parties from messaging, enabling private,
      secure, censorship-free communication with no single point of failure.
      It provides privacy-preserving capabilities, such as sender anonymity,
      metadata protection and unlinkability to personally identifiable information.
      Designed for generalized messaging, enabling human-to-human, machine-to-machine or hybrid communication.
    '';
    branch = "master";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ jakubgs ];
    platforms = with platforms; x86_64 ++ arm ++ aarch64;
    mainProgram = elemAt makeTargets 0;
  };
}
