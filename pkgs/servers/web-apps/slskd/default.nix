{ lib, stdenv
, buildNpmPackage
, fetchFromGitHub
, fetchurl
, unzip
, dotnetCorePackages
, buildDotnetModule
, mono
, nodejs_18
}:
let
  pname = "slskd";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "slskd";
    repo = "slskd";
    rev = version;
    sha256 = "sha256-hWK6nbXAZTjxukx9EzkJkyEFlqXUkjanmv4VfHZxW24=";
  };

  meta = with lib; {
    description = "A modern client-server application for the Soulseek file sharing network";
    homepage = "https://github.com/slskd/slskd";
    license = licenses.agpl3;
    maintainers = with maintainers; [ ppom ];
    platforms = platforms.linux;
  };

  buildNpmPackage' = buildNpmPackage.override { nodejs = nodejs_18; };

  wwwroot = buildNpmPackage' {
    inherit meta version;

    pname = "slskd-web";
    src = "${src}/src/web";
    npmFlags = [ "--legacy-peer-deps" ];
    npmDepsHash = "sha256-+2g3pCaGFbzQjKwhjmD6viuzVE5pRg+qSOXMrCtLQkI=";
    installPhase = ''
      cp -r build $out
    '';
  };

in buildDotnetModule {
  inherit pname version src meta;

  runtimeDeps = [ mono ];

  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_7_0;

  projectFile = "slskd.sln";

  testProjectFile = "tests/slskd.Tests.Unit/slskd.Tests.Unit.csproj";
  doCheck = true;

  nugetDeps = ./deps.nix;

  postInstall = ''
    rm -r $out/lib/slskd/wwwroot
    ln -s ${wwwroot} $out/lib/slskd/wwwroot
  '';
}
