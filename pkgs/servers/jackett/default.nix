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
<<<<<<< HEAD
  version = "0.24.532";
=======
  version = "0.22.2390";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "jackett";
    repo = "jackett";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-9dLBQOAyR2oyN1lGLPN/QLZtGLASRKUXUCLCdvqOmmE=";
=======
    hash = "sha512-Viz9gU16NG6nYeEwhar3OCSPnsHrM6ZehsOcNxteaGyvgrhbyWt5rNI54wCJ7OngHaZgIoQhMoNNkvIhX8JDUg==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  projectFile = "src/Jackett.Server/Jackett.Server.csproj";
  nugetDeps = ./deps.json;

<<<<<<< HEAD
  dotnet-runtime = dotnetCorePackages.aspnetcore_9_0;
  dotnet-sdk = dotnetCorePackages.sdk_9_0;

  dotnetInstallFlags = [
    "--framework"
    "net9.0"
=======
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;
  dotnet-sdk = dotnetCorePackages.sdk_8_0;

  dotnetInstallFlags = [
    "--framework"
    "net8.0"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  postPatch = ''
    substituteInPlace ${projectFile} ${testProjectFile} \
<<<<<<< HEAD
      --replace-fail '<TargetFrameworks>net9.0;net471</' '<TargetFrameworks>net9.0</'
  '';

  runtimeDeps = [ openssl ];
  # mono is not available on aarch64-darwin
  #x86_64-darwin is failed with
  #System.Net.Sockets.SocketException (13): Permission denied
  doCheck = !stdenv.hostPlatform.isDarwin;
=======
      --replace-fail '<TargetFrameworks>net8.0;net462</' '<TargetFrameworks>net8.0</'
  '';

  runtimeDeps = [ openssl ];

  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64); # mono is not available on aarch64-darwin
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
=======
      edwtjo
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      nyanloutre
      purcell
    ];
  };
}
