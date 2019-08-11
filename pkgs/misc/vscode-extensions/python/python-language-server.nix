{ stdenv, fetchurl, runCommand, callPackage, dotnetPackages, dotnet-sdk }:
 
let depsSource = runCommand "pls-deps" {
    buildInputs = [ dotnetPackages.Nuget ];
  } ''
  export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true
  export DOTNET_CLI_TELEMETRY_OPTOUT=1
  export HOME=$TMPDIR

  mkdir $out
  nuget sources Disable -Name "nuget.org"
  for package in ${toString (callPackage ./python-language-server-deps.nix {})}; do
    nuget add $package -Source $out
  done
'';
in
stdenv.mkDerivation rec {
    pname = "python-language-server";
    version = "0.2";
    src = fetchurl {
      url = "https://github.com/microsoft/python-language-server/archive/${version}.tar.gz";
      sha256 = "1p7z79n4x71bkssfq6qa4hgndpkfm25xird3hgfbdp1grrsssp5p";
    };
    buildInputs = [ dotnet-sdk dotnetPackages.Nuget ];
    installPhase = ''
      export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true
      export DOTNET_CLI_TELEMETRY_OPTOUT=1
      export HOME=$TMPDIR

      nuget sources Disable -Name "nuget.org"

      ( cd src/LanguageServer/Impl
        dotnet build --source ${depsSource}
      )
      mkdir $out
      cp -r output/bin/Debug/* $out
    '';
    passthru.depsSource = depsSource;
}
