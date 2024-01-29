{ lib, buildDotnetModule, fetchFromGitHub, dotnetCorePackages }:

let
  inherit (dotnetCorePackages) sdk_7_0;
in
buildDotnetModule rec {
  pname = "fsautocomplete";
  version = "0.69.0";

  src = fetchFromGitHub {
    owner = "fsharp";
    repo = "FsAutoComplete";
    rev = "v${version}";
    hash = "sha256-o0aR4yRzRb3y8vARuhP7JnBQ72XBX0whfpC51b2cqF0=";
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
