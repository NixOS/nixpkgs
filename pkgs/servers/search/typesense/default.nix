{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, nixosTests
}:
let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  sources = lib.importJSON ./sources.json;
  platform = sources.platforms.${system} or throwSystem;
  inherit (sources) version;
  inherit (platform) arch hash;
in
stdenv.mkDerivation {
  pname = "typesense";
  inherit version;
  src = fetchurl {
    url = "https://dl.typesense.org/releases/${version}/typesense-server-${version}-${arch}.tar.gz";
    inherit hash;
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  # The tar.gz contains no subdirectory
  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    cp $sourceRoot/typesense-server $out/bin
  '';

  passthru = {
    tests = { inherit (nixosTests) typesense; };
    updateScript = ./update.sh;
  };

  meta = with lib; {
    homepage = "https://typesense.org";
    description = "Typesense is a fast, typo-tolerant search engine for building delightful search experiences.";
    license = licenses.gpl3;
    # There has been an attempt at building this from source, which were deemed
    # unfeasible at the time of writing this (July 2023) for the following reasons.
    # - Pre 0.25 would have been possible, but typesense has switched to bazel for 0.25+,
    #   so the build would break immediately next version
    # - The new bazel build has many issues, only some of which were fixable:
    #   - preBuild requires export LANG="C.UTF-8", since onxxruntime contains a
    #     unicode file path that is handled incorrectly and otherwise leads to a build failure
    #   - bazel downloads extensions to the build systems at build time which have
    #     invalid shebangs that need to be fixed by patching rules_foreign_cc through
    #     bazel (so a patch in nix that adds a patch to the bazel WORKSPACE)
    #   - WORKSPACE has to be patched to use system cmake and ninja instead of downloaded toolchains
    #   - The cmake dependencies that are pulled in via bazel at build time will
    #     try to download stuff via cmake again, which is not possible in the sandbox.
    #     This is where I stopped trying for now.
    # XXX: retry once typesense has officially released their bazel based build.
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ oddlama ];
  };
}
