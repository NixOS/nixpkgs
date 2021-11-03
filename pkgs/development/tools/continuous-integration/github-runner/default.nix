{ autoPatchelfHook
, coreutils
, curl
, dotnetCorePackages
, dotnetPackages
, fetchFromGitHub
, fetchurl
, git
, glibc
, icu
, libkrb5
, lib
, linkFarm
, lttng-ust
, makeWrapper
, nodejs-12_x
, openssl
, stdenv
, zlib
}:
let
  deps = (import ./deps.nix { inherit fetchurl; });
  nugetPackages = map
    (x: {
      name = "${x.name}.nupkg";
      path = "${x}";
    })
    deps;
  nugetSource = linkFarm "nuget-packages" nugetPackages;

  dotnetSdk = dotnetCorePackages.sdk_3_1;
  runtimeId =
    if stdenv.isAarch64
    then "linux-arm64"
    else "linux-x64";
  fakeSha1 = "0000000000000000000000000000000000000000";
in
stdenv.mkDerivation rec {
  pname = "github-runner";
  version = "2.284.0";

  src = fetchFromGitHub {
    owner = "actions";
    repo = "runner";
    rev = "v${version}";
    sha256 = "sha256-JR0OzbT5gGhO/dxb/eSjP/d/VxW/aLmTs/oPwN8b8Rc=";
  };

  nativeBuildInputs = [
    dotnetSdk
    dotnetPackages.Nuget
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    curl # libcurl.so.4
    libkrb5 # libgssapi_krb5.so.2
    lttng-ust # liblttng-ust.so.0
    stdenv.cc.cc.lib # libstdc++.so.6
    zlib # libz.so.1
    icu
  ];

  patches = [
    # Don't run Git, no restore on build/test
    ./patches/dir-proj.patch
    # Replace some paths that originally point to Nix's read-only store
    ./patches/host-context-dirs.patch
    # Use GetDirectory() to obtain "diag" dir
    ./patches/use-get-directory-for-diag.patch
    # Don't try to install systemd service
    ./patches/dont-install-systemd-service.patch
    # Prevent the runner from starting a self-update for new versions
    # (upstream issue: https://github.com/actions/runner/issues/485)
    ./patches/prevent-self-update.patch
  ];

  postPatch = ''
    # Relax the version requirement
    substituteInPlace src/global.json \
      --replace '3.1.302' '${dotnetSdk.version}'

    # Disable specific tests
    substituteInPlace src/dir.proj \
      --replace 'dotnet test Test/Test.csproj' \
                "dotnet test Test/Test.csproj --filter '${lib.concatStringsSep "&amp;" disabledTests}'"

    # We don't use a Git checkout
    substituteInPlace src/dir.proj \
      --replace 'git update-index --assume-unchanged ./Runner.Sdk/BuildConstants.cs' \
                'echo Patched out.'

    # Fix FHS path
    substituteInPlace src/Test/L0/Util/IOUtilL0.cs \
      --replace '/bin/ln' '${coreutils}/bin/ln'
  '';

  configurePhase = ''
    runHook preConfigure

    # Set up Nuget dependencies
    export HOME=$(mktemp -d)
    export DOTNET_CLI_TELEMETRY_OPTOUT=1
    export DOTNET_NOLOGO=1

    # Never use nuget.org
    nuget sources Disable -Name "nuget.org"

    # Restore the dependencies
    dotnet restore src/ActionsRunner.sln \
      --runtime "${runtimeId}" \
      --source "${nugetSource}"

    runHook postConfigure
  '';

  postConfigure = ''
    # `crossgen` dependency is called during build
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}" \
      $HOME/.nuget/packages/microsoft.netcore.app.runtime.${runtimeId}/*/tools/crossgen
  '';

  buildPhase = ''
    runHook preBuild

    dotnet msbuild \
      -t:Build \
      -p:PackageRuntime="${runtimeId}" \
      -p:BUILDCONFIG="Release" \
      -p:RunnerVersion="${version}" \
      -p:GitInfoCommitHash="${fakeSha1}" \
      src/dir.proj

    runHook postBuild
  '';

  doCheck = true;

  disabledTests = [
    # Self-updating is patched out, hence this test will fail
    "FullyQualifiedName!=GitHub.Runner.Common.Tests.Listener.RunnerL0.TestRunOnceHandleUpdateMessage"
  ] ++ map
    # Online tests
    (x: "FullyQualifiedName!=GitHub.Runner.Common.Tests.Worker.ActionManagerL0.PrepareActions_${x}")
    [
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
    ] ++ map
    (x: "FullyQualifiedName!=GitHub.Runner.Common.Tests.DotnetsdkDownloadScriptL0.${x}")
    [
      "EnsureDotnetsdkBashDownloadScriptUpToDate"
      "EnsureDotnetsdkPowershellDownloadScriptUpToDate"
    ];

  checkInputs = [ git ];

  checkPhase = ''
    runHook preCheck

    mkdir -p _layout/externals
    ln -s ${nodejs-12_x} _layout/externals/node12

    # BUILDCONFIG needs to be "Debug"
    dotnet msbuild \
      -t:test \
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
    install -m755 src/Misc/layoutbin/runsvc.sh        $out/bin/
    install -m755 src/Misc/layoutbin/RunnerService.js $out/lib/
    install -m755 src/Misc/layoutroot/run.sh          $out/lib/
    install -m755 src/Misc/layoutroot/config.sh       $out/lib/
    install -m755 src/Misc/layoutroot/env.sh          $out/lib/

    # Rewrite reference in helper scripts from bin/ to lib/
    substituteInPlace $out/lib/run.sh    --replace '"$DIR"/bin' "$out/lib"
    substituteInPlace $out/lib/config.sh --replace './bin' "$out/lib"

    # Make paths absolute
    substituteInPlace $out/bin/runsvc.sh \
      --replace './externals' "$out/externals" \
      --replace './bin' "$out/lib"

    # The upstream package includes Node 12 and expects it at the path
    # externals/node12. As opposed to the official releases, we don't
    # link the Alpine Node flavor.
    mkdir -p $out/externals
    ln -s ${nodejs-12_x} $out/externals/node12

    runHook postInstall
  '';

  # Stripping breaks the binaries
  dontStrip = true;

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
        ''${@:2}
    }

    fix_rpath Runner.Listener
    fix_rpath Runner.PluginHost
    fix_rpath Runner.Worker

    wrap Runner.Listener
    wrap Runner.PluginHost
    wrap Runner.Worker
    wrap run.sh
    wrap env.sh

    wrap config.sh --prefix PATH : ${lib.makeBinPath [ glibc.bin ]}
  '';

  meta = with lib; {
    description = "Self-hosted runner for GitHub Actions";
    homepage = "https://github.com/actions/runner";
    license = licenses.mit;
    maintainers = with maintainers; [ veehaitch newam ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
