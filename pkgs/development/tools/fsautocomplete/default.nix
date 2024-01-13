{ lib, buildDotnetModule, fetchFromGitHub, dotnetCorePackages }:

let
  inherit (dotnetCorePackages) sdk_7_0;
in
buildDotnetModule rec {
  pname = "fsautocomplete";
  version = "0.68.0";

  src = fetchFromGitHub {
    owner = "fsharp";
    repo = "FsAutoComplete";
    rev = "v${version}";
    sha256 = "sha256-wAPTJXD2CxZQA2EG4rQCM9v3dIu6hn3q23K7Vv9wkAk=";
  };

  nugetDeps = ./deps.nix;

  postPatch = ''
    rm global.json

    substituteInPlace src/FsAutoComplete/FsAutoComplete.fsproj \
      --replace TargetFrameworks TargetFramework \
  '';

  dotnet-sdk = sdk_7_0;
  dotnet-runtime = sdk_7_0;

  projectFile = "src/FsAutoComplete/FsAutoComplete.fsproj";
  executables = [ "fsautocomplete" ];

  useDotnetFromEnv = true;

  meta = with lib; {
    description = "The FsAutoComplete project (FSAC) provides a backend service for rich editing or intellisense features for editors.";
    homepage = "https://github.com/fsharp/FsAutoComplete";
    changelog = "https://github.com/fsharp/FsAutoComplete/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gbtb mdarocha ];
  };
}
