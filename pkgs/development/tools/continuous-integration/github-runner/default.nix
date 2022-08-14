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
, linkFarmFromDrvs
, lttng-ust
, makeWrapper
, nodejs-16_x
, openssl
, stdenv
, zlib
, writeShellApplication
, nuget-to-nix
}:
let
  fetchNuGet = { pname, version, sha256 }: fetchurl {
    name = "${pname}.${version}.nupkg";
    url = "https://www.nuget.org/api/v2/package/${pname}/${version}";
    inherit sha256;
  };

  nugetSource = linkFarmFromDrvs "nuget-packages" (
    import ./deps.nix { inherit fetchNuGet; } ++
    dotnetSdk.passthru.packages { inherit fetchNuGet; }
  );

  dotnetSdk = dotnetCorePackages.sdk_6_0;
  # Map Nix systems to .NET runtime ids
  runtimeIds = {
    "x86_64-linux" = "linux-x64";
    "aarch64-linux" = "linux-arm64";
  };
  runtimeId = runtimeIds.${stdenv.system};
  fakeSha1 = "0000000000000000000000000000000000000000";
in
stdenv.mkDerivation rec {
  pname = "github-runner";
  version = "2.295.0";

  src = fetchFromGitHub {
    owner = "actions";
    repo = "runner";
    rev = "v${version}";
    hash = "sha256-C5tINoFkd2PRbpnlSkPL/o59B7+J+so07oVvJu1m3dk=";
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
  ];

  postPatch = ''
    # Relax the version requirement
    substituteInPlace src/global.json \
      --replace '6.0.300' '${dotnetSdk.version}'

    # Disable specific tests
    substituteInPlace src/dir.proj \
      --replace 'dotnet test Test/Test.csproj' \
                "dotnet test Test/Test.csproj --filter '${lib.concatStringsSep "&amp;" (map (x: "FullyQualifiedName!=${x}") disabledTests)}'"

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

    export HOME=$(mktemp -d)

    # Never use nuget.org
    nuget sources Disable -Name "nuget.org"

    # Restore the dependencies
    dotnet restore src/ActionsRunner.sln \
      --runtime "${runtimeId}" \
      --source "${nugetSource}"

    runHook postConfigure
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

  # Script to create deps.nix file for dotnet dependencies. Run it with
  # $(nix-build -A github-runner.passthru.createDepsFile)/bin/create-deps-file
  #
  # Default output path is /tmp/${pname}-deps.nix, but can be overriden with cli argument.
  #
  # Inspired by passthru.fetch-deps in pkgs/build-support/build-dotnet-module/default.nix
  passthru.createDepsFile = writeShellApplication {
    name = "create-deps-file";
    runtimeInputs = [ dotnetSdk nuget-to-nix ];
    text = ''
      # Disable telemetry data
      export DOTNET_CLI_TELEMETRY_OPTOUT=1

      rundir=$(pwd)

      printf "\n* Setup workdir\n"
      workdir="$(mktemp -d /tmp/${pname}.XXX)"
      cp -rT "${src}" "$workdir"
      chmod -R +w "$workdir"
      trap 'rm -rf "$workdir"' EXIT

      pushd "$workdir"

      mkdir nuget_pkgs

      ${lib.concatMapStrings (rid: ''
      printf "\n* Restore ${pname} (${rid}) dotnet project\n"
      dotnet restore src/ActionsRunner.sln --packages nuget_pkgs --no-cache --force --runtime "${rid}"
      '') (lib.attrValues runtimeIds)}

      cd "$rundir"
      deps_file=''${1-"/tmp/${pname}-deps.nix"}
      printf "\n* Make %s file\n" "$(basename "$deps_file")"
      nuget-to-nix "$workdir/nuget_pkgs" > "$deps_file"
      printf "\n* Dependency file writen to %s" "$deps_file"
    '';
  };

  meta = with lib; {
    description = "Self-hosted runner for GitHub Actions";
    homepage = "https://github.com/actions/runner";
    license = licenses.mit;
    maintainers = with maintainers; [ veehaitch newam kfollesdal ];
    platforms = attrNames runtimeIds;
  };
}
