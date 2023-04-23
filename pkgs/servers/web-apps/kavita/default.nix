{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  buildNpmPackage,
}:
buildDotnetModule rec {
  pname = "kavita";
  version = "0.7.1.4";

  src = fetchFromGitHub {
    owner = "kareadita";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jNhiwyz6iVSLlvMNjI689TwQYuEvTJ+QaPvvDQ4UOwc=";
  };

  patches = [
    # So that we can set the webroot
    ./change-webroot.diff
  ];

  frontend =  buildNpmPackage {
    pname = "kavita-web";
    inherit version src;

    sourceRoot = "source/UI/Web";

    npmBuildScript = "prod";
    npmFlags = [ "--legacy-peer-deps" ];
    npmRebuildFlags = [ "--ignore-scripts" ]; # Prevent playwright from trying to install browsers
    npmDepsHash = "sha256-w0CuTPyCQyAxULvqd6+GiZaPlO8fh4xLmbEnGA47pL8=";
  };

  postPatch = ''
    sed -i "s:@WEB_ROOT@:$out/lib/kavita-frontend:" API/Controllers/FallbackController.cs API/Startup.cs
  '';

  executables = [ "API" ];

  postFixup = ''
    cp -r $frontend/lib/node_modules/kavita-webui/dist $out/lib/kavita-frontend
    mv $out/bin/API $out/bin/kavita
  '';

  projectFile = "API/API.csproj";
  nugetDeps = ./nuget-deps.nix;
  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_6_0;

  meta = {
    description = "A fast, feature rich, cross platform reading server";
    homepage = "https://kavitareader.com";
    changelog = "https://github.com/${src.owner}/${src.repo}/releases/tag/${src.rev}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ misterio77 ];
  };
}
