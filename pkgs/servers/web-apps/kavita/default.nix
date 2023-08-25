{ lib
, stdenvNoCC
, fetchFromGitHub
, buildDotnetModule
, buildNpmPackage
, dotnetCorePackages
, nixosTests
, substituteAll
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kavita";
  version = "0.7.1.4";

  src = fetchFromGitHub {
    owner = "kareadita";
    repo = "kavita";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jNhiwyz6iVSLlvMNjI689TwQYuEvTJ+QaPvvDQ4UOwc=";
  };

  backend = buildDotnetModule {
    pname = "kavita-backend";
    inherit (finalAttrs) version src;

    patches = [
      # The webroot is hardcoded as ./wwwroot
      (substituteAll {
        src = ./change-webroot.diff;
        web_root = "${finalAttrs.frontend}/lib/node_modules/kavita-webui/dist";
      })
    ];

    executables = [ "API" ];

    projectFile = "API/API.csproj";
    nugetDeps = ./nuget-deps.nix;
    dotnet-sdk = dotnetCorePackages.sdk_6_0;
    dotnet-runtime = dotnetCorePackages.aspnetcore_6_0;
  };

  frontend =  buildNpmPackage {
    pname = "kavita-frontend";
    inherit (finalAttrs) version src;

    sourceRoot = "${finalAttrs.src.name}/UI/Web";

    npmBuildScript = "prod";
    npmFlags = [ "--legacy-peer-deps" ];
    npmRebuildFlags = [ "--ignore-scripts" ]; # Prevent playwright from trying to install browsers
    npmDepsHash = "sha256-w0CuTPyCQyAxULvqd6+GiZaPlO8fh4xLmbEnGA47pL8=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/kavita
    ln -s $backend/lib/kavita-backend $out/lib/kavita/backend
    ln -s $frontend/lib/node_modules/kavita-webui/dist $out/lib/kavita/frontend
    ln -s $backend/bin/API $out/bin/kavita

    runHook postInstall
  '';

  passthru.tests = { inherit (nixosTests) kavita; };

  meta = {
    description = "A fast, feature rich, cross platform reading server";
    homepage = "https://kavitareader.com";
    changelog = "https://github.com/kareadita/kavita/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ misterio77 ];
    mainProgram = "kavita";
  };
})
