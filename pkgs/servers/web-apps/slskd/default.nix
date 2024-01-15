{ lib
, buildNpmPackage
, fetchFromGitHub
, dotnetCorePackages
, buildDotnetModule
, mono
, nodejs_18
}:
let
  pname = "slskd";
  version = "0.19.5";

  src = fetchFromGitHub {
    owner = "slskd";
    repo = "slskd";
    rev = version;
    sha256 = "sha256-Vm+nA3yKiCMpQ41GTQF6Iuat89QrUtstQdHmX/DyU9g=";
  };

  meta = with lib; {
    description = "A modern client-server application for the Soulseek file sharing network";
    homepage = "https://github.com/slskd/slskd";
    license = licenses.agpl3;
    maintainers = with maintainers; [ ppom ];
    platforms = platforms.linux;
  };

  wwwroot = buildNpmPackage {
    inherit meta version;

    pname = "slskd-web";
    src = "${src}/src/web";
    npmFlags = [ "--legacy-peer-deps" ];
    nodejs = nodejs_18;
    npmDepsHash = "sha256-E1J4fYcY1N+UmN4Ch4Ss6ty+nYlmrv3ngvCJ8YCjPfI=";
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
