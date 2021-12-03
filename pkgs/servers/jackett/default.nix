{ lib
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
, openssl
}:

buildDotnetModule rec {
  pname = "jackett";
  version = "0.20.83";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "SR7XHRC6LrkDy0cu3D7sP+UQcqGLyQ9tzAmGfglA7sk=";
  };

  projectFile = "src/Jackett.Server/Jackett.Server.csproj";
  nugetDeps = ./deps.nix;

  dotnetInstallFlags = [ "-p:TargetFramework=net6.0" ];
  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_6_0;

  runtimeDeps = [ openssl ];

  postFixup = ''
    # Legacy
    ln -s $out/bin/jackett $out/bin/Jackett
  '';

  meta = with lib; {
    description = "API Support for your favorite torrent trackers";
    homepage = "https://github.com/Jackett/Jackett/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ edwtjo nyanloutre purcell ];
    platforms = platforms.all;
  };
  passthru.updateScript = ./updater.sh;
}
