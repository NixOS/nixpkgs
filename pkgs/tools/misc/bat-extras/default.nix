{ lib, stdenv, fetchFromGitHub, makeWrapper, bat
# batdiff, batgrep, and batwatch
, coreutils
, getconf
, less
# tests
, bash
, zsh
, fish
# batgrep
, ripgrep
# prettybat
, withShFmt ? shfmt != null, shfmt ? null
, withPrettier ? nodePackages?prettier, nodePackages ? null
, withClangTools ? clang-tools != null, clang-tools ? null
, withRustFmt ? rustfmt != null, rustfmt ? null
# batwatch
, withEntr ? entr != null, entr ? null
# batdiff
, gitMinimal
, withDelta ? delta != null, delta ? null
# batman
, util-linux
}:

let
  # Core derivation that all the others are based on.
  # This includes the complete source so the per-script derivations can run the tests.
  core = stdenv.mkDerivation rec {
    pname   = "bat-extras";
    version = "2021.04.06";

    src = fetchFromGitHub {
      owner  = "eth-p";
      repo   = pname;
      rev    = "v${version}";
      sha256 = "sha256-MphI2n+oHZrw8bPohNGeGdST5LS1c6s/rKqtpcR9cLo=";
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
    checkInputs = [ bash fish zsh ] ++ (lib.optionals stdenv.isDarwin [ getconf ]);
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

    meta = with lib; {
      description = "Bash scripts that integrate bat with various command line tools";
      homepage    = "https://github.com/eth-p/bat-extras";
      license     = with licenses; [ mit ];
      maintainers = with maintainers; [ bbigras lilyball ];
      platforms   = platforms.all;
    };
  };
  script =
    name: # the name of the script
    dependencies: # the tools we need to prefix onto PATH
    stdenv.mkDerivation {
      pname = "${core.pname}-${name}";
      inherit (core) version;

      src = core;

      nativeBuildInputs = [ makeWrapper ];
      # Make the dependencies available to the tests.
      buildInputs = dependencies;

      # Patch shebangs now because our tests rely on them
      postPatch = ''
        patchShebangs --host bin/${name}
      '';

      dontConfigure = true;
      dontBuild = true; # we've already built

      doCheck = true;
      checkInputs = [ bash fish zsh ] ++ (lib.optionals stdenv.isDarwin [ getconf ]);
      checkPhase = ''
        runHook preCheck
        bash ./test.sh --compiled --suite ${name}
        runHook postCheck
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        cp -p bin/${name} $out/bin/${name}
      '' + lib.optionalString (dependencies != []) ''
        wrapProgram $out/bin/${name} \
          --prefix PATH : ${lib.makeBinPath dependencies}
      '' + ''
        runHook postInstall
      '';

      # We already patched
      dontPatchShebangs = true;

      inherit (core) meta;
    };
  optionalDep = cond: dep:
    assert cond -> dep != null;
    lib.optional cond dep;
in
{
  batdiff = script "batdiff" ([ less coreutils gitMinimal ] ++ optionalDep withDelta delta);
  batgrep = script "batgrep" [ less coreutils ripgrep ];
  batman = script "batman" [ util-linux ];
  batpipe = script "batpipe" [ less ];
  batwatch = script "batwatch" ([ less coreutils ] ++ optionalDep withEntr entr);
  prettybat = script "prettybat" ([]
    ++ optionalDep withShFmt shfmt
    ++ optionalDep withPrettier nodePackages.prettier
    ++ optionalDep withClangTools clang-tools
    ++ optionalDep withRustFmt rustfmt);
}
