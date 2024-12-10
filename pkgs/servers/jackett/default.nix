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
  version = "0.22.893";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha512-W5Bmm426DOpnppP20a82ZwaUE9/HRUXXCKQUMK8TBgT1BUPPHykyW2Bew0u3U6NXXAX5EepyOb9lcidpBjN5RQ==";
  };

  projectFile = "src/Jackett.Server/Jackett.Server.csproj";
  nugetDeps = ./deps.nix;

  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;
  dotnet-sdk = dotnetCorePackages.sdk_8_0;

  dotnetInstallFlags = [ "-p:TargetFramework=net8.0" ];

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
