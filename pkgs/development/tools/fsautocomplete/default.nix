{ lib, fetchFromGitHub, dotnet_7, dotnet_6 }:

let
  dotnet = dotnet_7.withExtraSDKs [ dotnet_6.sdk ];

in dotnet.buildDotnetModule rec {
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

  dotnet-runtime = dotnet_7.sdk;

  projectFile = "src/FsAutoComplete/FsAutoComplete.fsproj";
  executables = [ "fsautocomplete" ];

  useDotnetFromEnv = true;

  meta = with lib; {
    description = "The FsAutoComplete project (FSAC) provides a backend service for rich editing or intellisense features for editors.";
    homepage = "https://github.com/fsharp/FsAutoComplete";
    changelog = "https://github.com/fsharp/FsAutoComplete/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gbtb mdarocha ];
  };
}
