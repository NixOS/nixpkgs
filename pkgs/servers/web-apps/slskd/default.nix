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
<<<<<<< HEAD
  version = "0.18.2";
=======
  version = "0.17.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "slskd";
    repo = "slskd";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-hWK6nbXAZTjxukx9EzkJkyEFlqXUkjanmv4VfHZxW24=";
=======
    sha256 = "sha256-iIM29ZI3M9etbw4yzin+4f4cGHIt5qjIl7uzsTUCBc4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    npmFlags = [ "--legacy-peer-deps" ];
    npmDepsHash = "sha256-+2g3pCaGFbzQjKwhjmD6viuzVE5pRg+qSOXMrCtLQkI=";
=======
    patches = [ ./package-lock.patch ];
    npmFlags = [ "--legacy-peer-deps" ];
    npmDepsHash = "sha256-vURi36ebdJQofhBlElIH5m6T1b8tsVGAzXCiDYUcSww=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
