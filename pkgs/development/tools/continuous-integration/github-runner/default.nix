{ lib
, stdenv
, buildDotnetModule
, fetchFromGitHub
, autoPatchelfHook
, makeWrapper
, dotnet-sdk_6
, coreutils
, nodejs-16_x
, openssl
, glibc
, lttng-ust
, zlib
, icu
, git
}:

let
  runtimeId = dotnet-sdk_6.systemToDotnetRid stdenv.hostPlatform.system;
  fakeSha1 = "0000000000000000000000000000000000000000";
in
buildDotnetModule rec {
  pname = "github-runner";
  version = "2.296.2";

  src = fetchFromGitHub {
    owner = "actions";
    repo = "runner";
    rev = "v${version}";
    hash = "sha256-Cpg17N4LXjMpKx9SB6Bq/1eKJH5B8yVDUwjxak7xykY=";
  };

  postPatch = ''
    # Relax the version requirement
    substituteInPlace src/global.json \
      --replace '6.0.300' '${dotnet-sdk_6.version}'

    # We don't use a Git checkout
    substituteInPlace src/dir.proj \
      --replace 'git update-index --assume-unchanged ./Runner.Sdk/BuildConstants.cs' \
                'echo Patched out.'

    # Disable specific tests
    substituteInPlace src/dir.proj \
      --replace 'dotnet test Test/Test.csproj' \
                "dotnet test Test/Test.csproj --filter '${lib.concatStringsSep "&amp;" (map (x: "FullyQualifiedName!=${x}") disabledTests)}'"

    # Fix FHS path
    substituteInPlace src/Test/L0/Util/IOUtilL0.cs \
      --replace '/bin/ln' '${coreutils}/bin/ln'
  '';

  patches = [
    # Don't run Git, no restore on build/test
    ./patches/dir-proj.patch
    # Replace some paths that originally point to Nix's read-only store
    ./patches/host-context-dirs.patch
    # Use GetDirectory() to obtain "diag" dir
    ./patches/use-get-directory-for-diag.patch
    # Don't try to install systemd service
    ./patches/dont-install-systemd-service.patch
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    lttng-ust
    zlib
    icu
  ];

  dotnetRestoreFlags = [ "--runtime ${runtimeId}" ];
  projectFile = [ "src/ActionsRunner.sln" ];
  nugetDeps = ./deps.nix;

  buildPhase = ''
    runHook preBuild

    dotnet msbuild \
      -t:Build \
      -p:BUILDCONFIG="Release" \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true \
      -p:PackageRuntime="${runtimeId}" \
      -p:RunnerVersion="${version}" \
      -p:GitInfoCommitHash="${fakeSha1}" \
      src/dir.proj

    runHook postBuild
  '';

  doCheck = true;

  # Fully qualified name of disabled tests
  disabledTests =
    [ "GitHub.Runner.Common.Tests.Listener.SelfUpdaterL0.TestSelfUpdateAsync" ]
    ++ map (x: "GitHub.Runner.Common.Tests.Listener.SelfUpdaterL0.TestSelfUpdateAsync_${x}") [
      "Cancel_CloneHashTask_WhenNotNeeded"
      "CloneHash_RuntimeAndExternals"
      "DownloadRetry"
      "FallbackToFullPackage"
      "NoUpdateOnOldVersion"
      "NotUseExternalsRuntimeTrimmedPackageOnHashMismatch"
      "UseExternalsRuntimeTrimmedPackage"
      "UseExternalsTrimmedPackage"
      "ValidateHash"
    ]
    ++ map (x: "GitHub.Runner.Common.Tests.Worker.ActionManagerL0.PrepareActions_${x}") [
      "CompositeActionWithActionfile_CompositeContainerNested"
      "CompositeActionWithActionfile_CompositePrestepNested"
      "CompositeActionWithActionfile_MaxLimit"
      "CompositeActionWithActionfile_Node"
      "DownloadActionFromGraph"
      "DownloadActionFromGraph_Legacy"
      "NotPullOrBuildImagesMultipleTimes"
      "NotPullOrBuildImagesMultipleTimes_Legacy"
      "RepositoryActionWithActionYamlFile_DockerHubImage"
      "RepositoryActionWithActionYamlFile_DockerHubImage_Legacy"
      "RepositoryActionWithActionfileAndDockerfile"
      "RepositoryActionWithActionfileAndDockerfile_Legacy"
      "RepositoryActionWithActionfile_DockerHubImage"
      "RepositoryActionWithActionfile_DockerHubImage_Legacy"
      "RepositoryActionWithActionfile_Dockerfile"
      "RepositoryActionWithActionfile_Dockerfile_Legacy"
      "RepositoryActionWithActionfile_DockerfileRelativePath"
      "RepositoryActionWithActionfile_DockerfileRelativePath_Legacy"
      "RepositoryActionWithActionfile_Node"
      "RepositoryActionWithActionfile_Node_Legacy"
      "RepositoryActionWithDockerfile"
      "RepositoryActionWithDockerfile_Legacy"
      "RepositoryActionWithDockerfileInRelativePath"
      "RepositoryActionWithDockerfileInRelativePath_Legacy"
      "RepositoryActionWithDockerfilePrepareActions_Repository"
      "RepositoryActionWithInvalidWrapperActionfile_Node"
      "RepositoryActionWithInvalidWrapperActionfile_Node_Legacy"
      "RepositoryActionWithWrapperActionfile_PreSteps"
      "RepositoryActionWithWrapperActionfile_PreSteps_Legacy"
    ]
    ++ map (x: "GitHub.Runner.Common.Tests.DotnetsdkDownloadScriptL0.${x}") [
      "EnsureDotnetsdkBashDownloadScriptUpToDate"
      "EnsureDotnetsdkPowershellDownloadScriptUpToDate"
    ]
    ++ [ "GitHub.Runner.Common.Tests.Listener.RunnerL0.TestRunOnceHandleUpdateMessage" ]
    # Tests for trimmed runner packages which aim at reducing the update size. Not relevant for Nix.
    ++ map (x: "GitHub.Runner.Common.Tests.PackagesTrimL0.${x}") [
      "RunnerLayoutParts_CheckExternalsHash"
      "RunnerLayoutParts_CheckDotnetRuntimeHash"
    ]
    ++ lib.optionals (stdenv.hostPlatform.system == "aarch64-linux") [
      # "JavaScript Actions in Alpine containers are only supported on x64 Linux runners. Detected Linux Arm64"
      "GitHub.Runner.Common.Tests.Worker.StepHostL0.DetermineNodeRuntimeVersionInAlpineContainerAsync"
    ];

  checkInputs = [ git ];

  checkPhase = ''
    runHook preCheck

    mkdir -p _layout/externals
    ln -s ${nodejs-16_x} _layout/externals/node16

    printf 'Disabled tests:\n%s\n' '${lib.concatMapStringsSep "\n" (x: " - ${x}") disabledTests}'

    # BUILDCONFIG needs to be "Debug"
    dotnet msbuild \
      -t:test \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true \
      -p:PackageRuntime="${runtimeId}" \
      -p:BUILDCONFIG="Debug" \
      -p:RunnerVersion="${version}" \
      -p:GitInfoCommitHash="${fakeSha1}" \
      src/dir.proj

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    # Copy the built binaries to lib/ instead of bin/ as they
    # have to be wrapped in the fixup phase to work
    mkdir -p $out/lib
    cp -r _layout/bin/. $out/lib/

    # Delete debugging files
    find "$out/lib" -type f -name '*.pdb' -delete

    # Install the helper scripts to bin/ to resemble the upstream package
    mkdir -p $out/bin
    install -m755 src/Misc/layoutbin/runsvc.sh                 $out/bin/
    install -m755 src/Misc/layoutbin/RunnerService.js          $out/lib/
    install -m755 src/Misc/layoutroot/run.sh                   $out/lib/
    install -m755 src/Misc/layoutroot/run-helper.sh.template   $out/lib/run-helper.sh
    install -m755 src/Misc/layoutroot/config.sh                $out/lib/
    install -m755 src/Misc/layoutroot/env.sh                   $out/lib/

    # Rewrite reference in helper scripts from bin/ to lib/
    substituteInPlace $out/lib/config.sh --replace './bin' $out'/lib' \
      --replace 'source ./env.sh' $out/bin/env.sh

    # Remove uneeded copy for run-helper template
    substituteInPlace $out/lib/run.sh --replace 'cp -f "$DIR"/run-helper.sh.template "$DIR"/run-helper.sh' ' '
    substituteInPlace $out/lib/run-helper.sh --replace '"$DIR"/bin/' '"$DIR"/'

    # Make paths absolute
    substituteInPlace $out/bin/runsvc.sh \
      --replace './externals' "$out/externals" \
      --replace './bin' "$out/lib"

    # The upstream package includes Node {12,16} and expects it at the path
    # externals/node{12,16}. As opposed to the official releases, we don't
    # link the Alpine Node flavors.
    mkdir -p $out/externals
    ln -s ${nodejs-16_x} $out/externals/node16

    # Install Nodejs scripts called from workflows
    install -D src/Misc/layoutbin/hashFiles/index.js $out/lib/hashFiles/index.js
    mkdir -p $out/lib/checkScripts
    install src/Misc/layoutbin/checkScripts/* $out/lib/checkScripts/

    runHook postInstall
  '';

  preFixup = ''
    patchelf --replace-needed liblttng-ust.so.0 liblttng-ust.so $out/lib/libcoreclrtraceptprovider.so
  '';

  postFixup = ''
    fix_rpath() {
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/lib/$1
    }

    wrap() {
      makeWrapper $out/lib/$1 $out/bin/$1 \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath (buildInputs ++ [ openssl ])} \
        "''${@:2}"
    }

    fix_rpath Runner.Listener
    fix_rpath Runner.PluginHost
    fix_rpath Runner.Worker

    wrap Runner.Listener
    wrap Runner.PluginHost
    wrap Runner.Worker
    wrap run.sh --run 'export RUNNER_ROOT=''${RUNNER_ROOT:-$HOME/.github-runner}'
    wrap env.sh --run 'cd $RUNNER_ROOT'

    wrap config.sh --run 'export RUNNER_ROOT=''${RUNNER_ROOT:-$HOME/.github-runner}' \
      --run 'mkdir -p $RUNNER_ROOT' \
      --prefix PATH : ${lib.makeBinPath [ glibc.bin ]} \
      --chdir $out
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Self-hosted runner for GitHub Actions";
    changelog = "https://github.com/actions/runner/releases/tag/v${version}";
    homepage = "https://github.com/actions/runner";
    license = licenses.mit;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ veehaitch newam kfollesdal ];
  };
}
