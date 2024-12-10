{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:

buildDotnetModule rec {
  pname = "fsautocomplete";
  version = "0.72.3";

  src = fetchFromGitHub {
    owner = "fsharp";
    repo = "FsAutoComplete";
    rev = "v${version}";
    hash = "sha256-YU2rb1rxlbreSXMO+IGS2BrdfmqntdSlLuxV3zekSaI=";
  };

  nugetDeps = ./deps.nix;

  postPatch = ''
    rm global.json

    substituteInPlace src/FsAutoComplete/FsAutoComplete.fsproj \
      --replace TargetFrameworks TargetFramework \
  '';

  dotnet-sdk =
    with dotnetCorePackages;
    combinePackages [
      sdk_6_0
      sdk_7_0
      sdk_8_0_2xx
    ];
  dotnet-runtime = dotnetCorePackages.sdk_8_0_2xx;

  projectFile = "src/FsAutoComplete/FsAutoComplete.fsproj";
  executables = [ "fsautocomplete" ];

  useDotnetFromEnv = true;

  meta = with lib; {
    description = "The FsAutoComplete project (FSAC) provides a backend service for rich editing or intellisense features for editors.";
    mainProgram = "fsautocomplete";
    homepage = "https://github.com/fsharp/FsAutoComplete";
    changelog = "https://github.com/fsharp/FsAutoComplete/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      gbtb
      mdarocha
    ];
  };
}
