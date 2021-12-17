{ lib
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
, openssl
}:

buildDotnetModule rec {
  pname = "jackett";
  version = "0.19.138";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0qaaccc95csahylzv65ndx990kcr075jffawbjpsjfkxzflfjq9n";
  };

  projectFile = "src/Jackett.Server/Jackett.Server.csproj";
  nugetDeps = ./deps.nix;

  dotnetInstallFlags = [ "-p:TargetFramework=net5.0" ];
  dotnet-runtime = dotnetCorePackages.aspnetcore_5_0;

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
