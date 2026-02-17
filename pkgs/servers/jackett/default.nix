{
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  openssl,
  mono,
  nixosTests,
}:

buildDotnetModule rec {
  pname = "jackett";
  version = "0.24.1066";

  src = fetchFromGitHub {
    owner = "jackett";
    repo = "jackett";
    tag = "v${version}";
    hash = "sha256-o0Mu5+m6+2iVRIJ8OIlUDNUY9h3qKn1hOsSA1JYd71o=";
  };

  projectFile = "src/Jackett.Server/Jackett.Server.csproj";
  nugetDeps = ./deps.json;

  dotnet-runtime = dotnetCorePackages.aspnetcore_9_0;
  dotnet-sdk = dotnetCorePackages.sdk_9_0;

  dotnetInstallFlags = [
    "--framework"
    "net9.0"
  ];

  postPatch = ''
    substituteInPlace ${projectFile} ${testProjectFile} \
      --replace-fail '<TargetFrameworks>net9.0;net471</' '<TargetFrameworks>net9.0</'
  '';

  runtimeDeps = [ openssl ];
  # mono is not available on aarch64-darwin
  #x86_64-darwin is failed with
  #System.Net.Sockets.SocketException (13): Permission denied
  doCheck = !stdenv.hostPlatform.isDarwin;
  nativeCheckInputs = [ mono ];
  testProjectFile = "src/Jackett.Test/Jackett.Test.csproj";

  postFixup = ''
    # For compatibility
    ln -s $out/bin/jackett $out/bin/Jackett || :
    ln -s $out/bin/Jackett $out/bin/jackett || :
  '';
  passthru.updateScript = ./updater.sh;

  passthru.tests = { inherit (nixosTests) jackett; };

  meta = {
    description = "API Support for your favorite torrent trackers";
    mainProgram = "jackett";
    homepage = "https://github.com/Jackett/Jackett/";
    changelog = "https://github.com/Jackett/Jackett/releases/tag/v${version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      nyanloutre
      purcell
    ];
  };
}
