{ autoSignDarwinBinariesHook
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
, fetchpatch
, git
, glibc
, glibcLocales
, lib
, nixosTests
, stdenv
, which
, buildPackages
, runtimeShell
  # List of Node.js runtimes the package should support
, nodeRuntimes ? [ "node20" ]
, nodejs_20
}:

# Node.js runtimes supported by upstream
assert builtins.all (x: builtins.elem x [ "node20" ]) nodeRuntimes;

buildDotnetModule rec {
  pname = "github-runner";
  version = "2.317.0";

  src = fetchFromGitHub {
    owner = "actions";
    repo = "runner";
    rev = "v${version}";
    hash = "sha256-+VwEH4hmEjeYFWm7TOndD5SOJwsyPZEhKkCSyl7x8cE=";
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse --short HEAD > $out/.git-revision
      rm -rf $out/.git
    '';
  };

  # The git commit is read during the build and some tests depend on a git repo to be present
  # https://github.com/actions/runner/blob/22d1938ac420a4cb9e3255e47a91c2e43c38db29/src/dir.proj#L5
  unpackPhase = ''
    cp -r $src $TMPDIR/src
    chmod -R +w $TMPDIR/src
    cd $TMPDIR/src
    (
      export PATH=${buildPackages.git}/bin:$PATH
      git init
      git config user.email "root@localhost"
      git config user.name "root"
      git add .
      git commit -m "Initial commit"
      git checkout -b v${version}
    )
    mkdir -p $TMPDIR/bin
    cat > $TMPDIR/bin/git <<EOF
    #!${runtimeShell}
    if [ \$# -eq 1 ] && [ "\$1" = "rev-parse" ]; then
      echo $(cat $TMPDIR/src/.git-revision)
      exit 0
    fi
    exec ${buildPackages.git}/bin/git "\$@"
    EOF
    chmod +x $TMPDIR/bin/git
    export PATH=$TMPDIR/bin:$PATH
  '';

  patches = [
    # Replace some paths that originally point to Nix's read-only store
    ./patches/host-context-dirs.patch
    # Use GetDirectory() to obtain "diag" dir
    ./patches/use-get-directory-for-diag.patch
    # Don't try to install service
    ./patches/dont-install-service.patch
    # Access `.env` and `.path` relative to `$RUNNER_ROOT`, if set
    ./patches/env-sh-use-runner-root.patch
    # Fix FHS path: https://github.com/actions/runner/pull/2464
    (fetchpatch {
      name = "ln-fhs.patch";
      url = "https://github.com/actions/runner/commit/5ff0ce1.patch";
      hash = "sha256-2Vg3cKZK3cE/OcPDZkdN2Ro2WgvduYTTwvNGxwCfXas=";
    })
  ] ++ lib.optionals (nodeRuntimes == [ "node20" ]) [
    # If the package is built without Node 16, make Node 20 the default internal version
    # https://github.com/actions/runner/pull/2844
    (fetchpatch {
      name = "internal-node-20.patch";
      url = "https://github.com/actions/runner/commit/acdc6ed.patch";
      hash = "sha256-3/6yhhJPr9OMWBFc5/NU/DRtn76aTYvjsjQo2u9ZqnU=";
    })
  ];

  postPatch = ''
    # Ignore changes to src/Runner.Sdk/BuildConstants.cs
    substituteInPlace src/dir.proj \
      --replace 'git update-index --assume-unchanged ./Runner.Sdk/BuildConstants.cs' \
                'true'
  '';

  DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = isNull glibcLocales;
  LOCALE_ARCHIVE = lib.optionalString (!DOTNET_SYSTEM_GLOBALIZATION_INVARIANT) "${glibcLocales}/lib/locale/locale-archive";

  postConfigure = ''
    # Generate src/Runner.Sdk/BuildConstants.cs
    dotnet msbuild \
      -t:GenerateConstant \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true \
      -p:PackageRuntime="${dotnetCorePackages.systemToDotnetRid stdenv.hostPlatform.system}" \
      -p:RunnerVersion="${version}" \
      src/dir.proj
  '';

  nativeBuildInputs = [
    which
    git
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    autoSignDarwinBinariesHook
  ];

  buildInputs = [ stdenv.cc.cc.lib ];

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.runtime_6_0;

  dotnetFlags = [ "-p:PackageRuntime=${dotnetCorePackages.systemToDotnetRid stdenv.hostPlatform.system}" ];

  # As given here: https://github.com/actions/runner/blob/0befa62/src/dir.proj#L33-L41
  projectFile = [
    "src/Sdk/Sdk.csproj"
    "src/Runner.Common/Runner.Common.csproj"
    "src/Runner.Listener/Runner.Listener.csproj"
    "src/Runner.Worker/Runner.Worker.csproj"
    "src/Runner.PluginHost/Runner.PluginHost.csproj"
    "src/Runner.Sdk/Runner.Sdk.csproj"
    "src/Runner.Plugins/Runner.Plugins.csproj"
  ];
  nugetDeps = ./deps.nix;

  doCheck = true;

  __darwinAllowLocalNetworking = true;

  # Fully qualified name of disabled tests
  disabledTests =
    [
      "GitHub.Runner.Common.Tests.Listener.SelfUpdaterL0.TestSelfUpdateAsync"
      "GitHub.Runner.Common.Tests.ProcessInvokerL0.OomScoreAdjIsInherited"
    ]
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
    ++ map (x: "GitHub.Runner.Common.Tests.Listener.SelfUpdaterV2L0.${x}") [
      "TestSelfUpdateAsync_DownloadRetry"
      "TestSelfUpdateAsync_ValidateHash"
      "TestSelfUpdateAsync"
    ]
    ++ map (x: "GitHub.Runner.Common.Tests.Worker.ActionManagerL0.PrepareActions_${x}") [
      "CompositeActionWithActionfile_CompositeContainerNested"
      "CompositeActionWithActionfile_CompositePrestepNested"
      "CompositeActionWithActionfile_MaxLimit"
      "CompositeActionWithActionfile_Node"
      "DownloadActionFromGraph"
      "NotPullOrBuildImagesMultipleTimes"
      "RepositoryActionWithActionYamlFile_DockerHubImage"
      "RepositoryActionWithActionfileAndDockerfile"
      "RepositoryActionWithActionfile_DockerHubImage"
      "RepositoryActionWithActionfile_Dockerfile"
      "RepositoryActionWithActionfile_DockerfileRelativePath"
      "RepositoryActionWithActionfile_Node"
      "RepositoryActionWithDockerfile"
      "RepositoryActionWithDockerfileInRelativePath"
      "RepositoryActionWithDockerfilePrepareActions_Repository"
      "RepositoryActionWithInvalidWrapperActionfile_Node"
      "RepositoryActionWithWrapperActionfile_PreSteps"
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
      "GitHub.Runner.Common.Tests.Worker.StepHostL0.DetermineNode20RuntimeVersionInAlpineContainerAsync"
    ]
    ++ lib.optionals DOTNET_SYSTEM_GLOBALIZATION_INVARIANT [
      "GitHub.Runner.Common.Tests.ProcessExtensionL0.SuccessReadProcessEnv"
      "GitHub.Runner.Common.Tests.Util.StringUtilL0.FormatUsesInvariantCulture"
      "GitHub.Runner.Common.Tests.Worker.VariablesL0.Constructor_SetsOrdinalIgnoreCaseComparer"
      "GitHub.Runner.Common.Tests.Worker.WorkerL0.DispatchCancellation"
      "GitHub.Runner.Common.Tests.Worker.WorkerL0.DispatchRunNewJob"
    ]
    ++ lib.optionals (!lib.elem "node16" nodeRuntimes) [
      "GitHub.Runner.Common.Tests.ProcessExtensionL0.SuccessReadProcessEnv"
    ];

  testProjectFile = [ "src/Test/Test.csproj" ];

  preCheck = ''
    mkdir -p _layout/externals
  '' + lib.optionalString (lib.elem "node20" nodeRuntimes) ''
    ln -s ${nodejs_20} _layout/externals/node20
  '';

  postInstall = ''
    mkdir -p $out/bin

    install -m755 src/Misc/layoutbin/runsvc.sh                 $out/lib/github-runner
    install -m755 src/Misc/layoutbin/RunnerService.js          $out/lib/github-runner
    install -m755 src/Misc/layoutroot/run.sh                   $out/lib/github-runner
    install -m755 src/Misc/layoutroot/run-helper.sh.template   $out/lib/github-runner/run-helper.sh
    install -m755 src/Misc/layoutroot/config.sh                $out/lib/github-runner
    install -m755 src/Misc/layoutroot/env.sh                   $out/lib/github-runner

    # env.sh is patched to not require any wrapping
    ln -sr "$out/lib/github-runner/env.sh" "$out/bin/"

    substituteInPlace $out/lib/github-runner/config.sh \
      --replace './bin/Runner.Listener' "$out/bin/Runner.Listener"
  '' + lib.optionalString stdenv.isLinux ''
    substituteInPlace $out/lib/github-runner/config.sh \
      --replace 'command -v ldd' 'command -v ${glibc.bin}/bin/ldd' \
      --replace 'ldd ./bin' '${glibc.bin}/bin/ldd ${dotnet-runtime}/shared/Microsoft.NETCore.App/${dotnet-runtime.version}/' \
      --replace '/sbin/ldconfig' '${glibc.bin}/bin/ldconfig'
  '' + ''
    # Remove uneeded copy for run-helper template
    substituteInPlace $out/lib/github-runner/run.sh --replace 'cp -f "$DIR"/run-helper.sh.template "$DIR"/run-helper.sh' ' '
    substituteInPlace $out/lib/github-runner/run-helper.sh --replace '"$DIR"/bin/' '"$DIR"/'

    # Make paths absolute
    substituteInPlace $out/lib/github-runner/runsvc.sh \
      --replace './externals' "$out/lib/externals" \
      --replace './bin/RunnerService.js' "$out/lib/github-runner/RunnerService.js"

    # The upstream package includes Node and expects it at the path
    # externals/node$version. As opposed to the official releases, we don't
    # link the Alpine Node flavors.
    mkdir -p $out/lib/externals
  '' + lib.optionalString (lib.elem "node20" nodeRuntimes) ''
    ln -s ${nodejs_20} $out/lib/externals/node20
  '' + ''
    # Install Nodejs scripts called from workflows
    install -D src/Misc/layoutbin/hashFiles/index.js $out/lib/github-runner/hashFiles/index.js
    mkdir -p $out/lib/github-runner/checkScripts
    install src/Misc/layoutbin/checkScripts/* $out/lib/github-runner/checkScripts/
  '' + lib.optionalString stdenv.isLinux ''
    # Wrap explicitly to, e.g., prevent extra entries for LD_LIBRARY_PATH
    makeWrapperArgs=()

    # We don't wrap with libicu
    substituteInPlace $out/lib/github-runner/config.sh \
      --replace '$LDCONFIG_COMMAND -NXv ''${libpath//:/ }' 'echo libicu'
  '' + ''
    # XXX: Using the corresponding Nix argument does not work as expected:
    #      https://github.com/NixOS/nixpkgs/issues/218449
    # Common wrapper args for `executables`
    makeWrapperArgs+=(
      --run 'export RUNNER_ROOT="''${RUNNER_ROOT:-"$HOME/.github-runner"}"'
      --run 'mkdir -p "$RUNNER_ROOT"'
      --chdir "$out"
    )
  '';

  # List of files to wrap
  executables = [
    "config.sh"
    "Runner.Listener"
    "Runner.PluginHost"
    "Runner.Worker"
    "run.sh"
    "runsvc.sh"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    export RUNNER_ROOT="$TMPDIR"

    $out/bin/config.sh --help >/dev/null
    $out/bin/Runner.Listener --help >/dev/null

    version=$($out/bin/Runner.Listener --version)
    if [[ "$version" != "${version}" ]]; then
      printf 'Unexpected version %s' "$version"
      exit 1
    fi

    commit=$($out/bin/Runner.Listener --commit)
    if [[ "$commit" != "$(git rev-parse HEAD)" ]]; then
      printf 'Unexpected commit %s' "$commit"
      exit 1
    fi

    runHook postInstallCheck
  '';

  passthru = {
    tests.smoke-test = nixosTests.github-runner;
    updateScript = ./update.sh;
  };

  meta = with lib; {
    changelog = "https://github.com/actions/runner/releases/tag/v${version}";
    description = "Self-hosted runner for GitHub Actions";
    homepage = "https://github.com/actions/runner";
    license = licenses.mit;
    maintainers = with maintainers; [ veehaitch newam kfollesdal aanderse zimbatm ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
