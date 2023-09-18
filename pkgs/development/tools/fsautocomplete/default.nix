{ lib, buildDotnetModule, fetchFromGitHub, dotnetCorePackages, stdenv }:

let
  inherit (dotnetCorePackages) combinePackages sdk_6_0 sdk_7_0;
in
buildDotnetModule rec {
  pname = "fsautocomplete";
  version = "0.63.0";

  src = fetchFromGitHub {
    owner = "fsharp";
    repo = "FsAutoComplete";
    rev = "v${version}";
    sha256 = "sha256-Or7KjJVi0N8edO+Q8bBCNrNAE974ClJfXT7Co8YXWjI=";
  };

  nugetDeps = ./deps.nix;

  postPatch = ''
    rm global.json

    substituteInPlace src/FsAutoComplete/FsAutoComplete.fsproj \
      --replace TargetFrameworks TargetFramework \
  '';

  dotnet-sdk = combinePackages [
    sdk_7_0
    sdk_6_0
  ];
  dotnet-runtime = sdk_6_0;

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
