{
  lib,
  fetchFromGitHub,
  stdenv,
  bash,
  bat,
  fish,
  getconf,
  nix-update-script,
  nushell,
  zsh,
}:
stdenv.mkDerivation {
  pname = "bat-extras";
  version = "2024.08.24-unstable-2025-02-22";

  src = fetchFromGitHub {
    owner = "eth-p";
    repo = "bat-extras";
    rev = "3860f0f1481f1d0e117392030f55ef19cc018ee4";
    hash = "sha256-9TEq/LzE1Pty1Z3WFWR/TaNNKPp2LGBr0jzGBkOEGQo=";
    fetchSubmodules = true;
  };

  # bat needs to be in the PATH during building so EXECUTABLE_BAT picks it up
  nativeBuildInputs = [ bat ];

  dontConfigure = true;

  postPatch = ''
    patchShebangs --build test.sh test/shimexec .test-framework/bin/best.sh
  '';

  buildPhase = ''
    runHook preBuild
    bash ./build.sh --minify=none --no-verify
    runHook postBuild
  '';

  # Run the library tests as they don't have external dependencies
  doCheck = true;
  nativeCheckInputs = [
    bash
    fish
    nushell
    zsh
  ]
  ++ (lib.optionals stdenv.hostPlatform.isDarwin [ getconf ]);
  checkPhase = ''
    runHook preCheck
    # test list repeats suites. Unique them
    declare -A test_suites
    while read -r action arg _; do
      [[ "$action" == "test_suite" && "$arg" == lib_* ]] &&
      test_suites+=(["$arg"]=1)
    done <<<"$(./test.sh --compiled --list --porcelain)"
    (( ''${#test_suites[@]} != 0 )) || {
      echo "Couldn't find any library test suites"
      exit 1
    }
    ./test.sh --compiled $(printf -- "--suite %q\n" "''${!test_suites[@]}")
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    cp -a . $out
    runHook postInstall
  '';

  # A few random files have shebangs. Don't patch them, they don't make it into the final output.
  # The per-script derivations will go ahead and patch the files they actually install.
  dontPatchShebangs = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Bash scripts that integrate bat with various command line tools";
    homepage = "https://github.com/eth-p/bat-extras";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      bbigras
      perchun
    ];
    platforms = lib.platforms.all;
  };
}
