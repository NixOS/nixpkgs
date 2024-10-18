{ lib, buildDotnetModule, fetchFromGitHub, fetchpatch, dotnetCorePackages }:

buildDotnetModule rec {
  pname = "fsautocomplete";
  version = "0.73.2";

  src = fetchFromGitHub {
    owner = "fsharp";
    repo = "FsAutoComplete";
    rev = "v${version}";
    hash = "sha256-iiV/Tw3gOteARrOEbLjPA/jGawoxJVBZg6GvF9p9HHA=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/ionide/FsAutoComplete/pull/1311/commits/e258ba3db47daec9d5befcdc1ae79484c2804cf4.patch";
      hash = "sha256-bKTk5gszyVZObvq78emAtqE6bBg+1doseoxjUnrjOH4=";
    })
  ];

  nugetDeps = ./deps.nix;

  postPatch = ''
    rm global.json

    substituteInPlace src/FsAutoComplete/FsAutoComplete.fsproj \
      --replace TargetFrameworks TargetFramework \
  '';

  dotnet-sdk = with dotnetCorePackages; combinePackages [ sdk_6_0 sdk_7_0 sdk_8_0 ];
  dotnet-runtime = dotnetCorePackages.sdk_8_0;

  projectFile = "src/FsAutoComplete/FsAutoComplete.fsproj";
  executables = [ "fsautocomplete" ];

  useDotnetFromEnv = true;

  meta = with lib; {
    description = "FsAutoComplete project (FSAC) provides a backend service for rich editing or intellisense features for editors";
    mainProgram = "fsautocomplete";
    homepage = "https://github.com/fsharp/FsAutoComplete";
    changelog = "https://github.com/fsharp/FsAutoComplete/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gbtb mdarocha ];
  };
}
