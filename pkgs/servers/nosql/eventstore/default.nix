{ lib
, git
, dotnetCorePackages
, glibcLocales
, buildDotnetModule
, fetchFromGitHub
, bintools
, stdenv
, mono
}:
let
  mainProgram = "EventStore.ClusterNode";
in

buildDotnetModule rec {
  pname = "EventStore";
  version = "23.6.0";

  src = fetchFromGitHub {
    owner = "EventStore";
    repo = "EventStore";
    rev = "oss-v${version}";
    sha256 = "sha256-+Wxm6yusaCoqXIbsi0ZoALAviKUyNMQwbzsQtBK/PCo=";
    leaveDotGit = true;
  };

  # Fixes application reporting 0.0.0.0 as its version.
  MINVERVERSIONOVERRIDE = version;

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_6_0;

  nativeBuildInputs = [ git glibcLocales bintools ];

  runtimeDeps = [ mono ];

  executables = [ mainProgram ];

  # This test has a problem running on macOS
  disabledTests = lib.optionals stdenv.isDarwin [
    "EventStore.Projections.Core.Tests.Services.grpc_service.ServerFeaturesTests<LogFormat+V2,String>.should_receive_expected_endpoints"
    "EventStore.Projections.Core.Tests.Services.grpc_service.ServerFeaturesTests<LogFormat+V3,UInt32>.should_receive_expected_endpoints"
  ];

  postConfigure = ''
    # Fixes git execution by GitInfo on mac os
    substituteInPlace "$HOME/.nuget/packages/gitinfo/2.0.26/build/GitInfo.targets" \
      --replace "<GitExe Condition=\"Exists('/usr/bin/git')\">/usr/bin/git</GitExe>" " " \
      --replace "<GitExe Condition=\"Exists('/usr/local/bin/git')\">/usr/local/bin/git</GitExe>" ""
  '';

  nugetDeps = ./deps.nix;

  projectFile = "src/EventStore.ClusterNode/EventStore.ClusterNode.csproj";

  doCheck = true;
  testProjectFile = "src/EventStore.Projections.Core.Tests/EventStore.Projections.Core.Tests.csproj";

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/EventStore.ClusterNode --insecure \
      --db "$HOME/data" \
      --index "$HOME/index" \
      --log "$HOME/log" \
      -runprojections all --startstandardprojections \
      --EnableAtomPubOverHttp &

    PID=$!

    sleep 30s;
    kill "$PID";
  '';

  passthru.updateScript = ./updater.sh;

  meta = with lib; {
    homepage = "https://geteventstore.com/";
    description = "Event sourcing database with processing logic in JavaScript";
    license = licenses.bsd3;
    maintainers = with maintainers; [ puffnfresh mdarocha ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    inherit mainProgram;
  };
}
