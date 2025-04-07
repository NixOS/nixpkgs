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
  version = "0.22.1705";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    tag = "v${version}";
    hash = "sha512-AnyCT52wZR+2rhUXg3BOaWo7ESZUQNMLtaiVld2c2vYw7atq78N+uDFUIYfsvxemDAStB5tjw1mdwdLevzCkTA==";
  };

  projectFile = "src/Jackett.Server/Jackett.Server.csproj";
  nugetDeps = ./deps.json;

  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;
  dotnet-sdk = dotnetCorePackages.sdk_8_0;

  dotnetInstallFlags = [
    "--framework"
    "net8.0"
  ];

  postPatch = ''
    substituteInPlace ${projectFile} ${testProjectFile} \
      --replace-fail '<TargetFrameworks>net8.0;net462</' '<TargetFrameworks>net8.0</'
  '';

  runtimeDeps = [ openssl ];

  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64); # mono is not available on aarch64-darwin
  nativeCheckInputs = [ mono ];
  testProjectFile = "src/Jackett.Test/Jackett.Test.csproj";

  postFixup = ''
    # For compatibility
    ln -s $out/bin/jackett $out/bin/Jackett || :
    ln -s $out/bin/Jackett $out/bin/jackett || :
  '';
  passthru.updateScript = ./updater.sh;

  passthru.tests = { inherit (nixosTests) jackett; };

  meta = with lib; {
    description = "API Support for your favorite torrent trackers";
    mainProgram = "jackett";
    homepage = "https://github.com/Jackett/Jackett/";
    changelog = "https://github.com/Jackett/Jackett/releases/tag/v${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      edwtjo
      nyanloutre
      purcell
    ];
  };
}
