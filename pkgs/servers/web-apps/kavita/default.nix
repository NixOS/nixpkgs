{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchpatch2,
  buildDotnetModule,
  buildNpmPackage,
  dotnetCorePackages,
  nixosTests,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kavita";
  version = "0.8.5.11";

  src = fetchFromGitHub {
    owner = "kareadita";
    repo = "kavita";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HSVdEB0yhmm/SZseHQ5kTRBaVqCZZx934Ovq1pTmQkM=";
  };

  backend = buildDotnetModule {
    pname = "kavita-backend";
    inherit (finalAttrs) version src;

    patches = [
      # The webroot is hardcoded as ./wwwroot
      ./change-webroot.diff
      # Upstream removes database migrations between versions
      # Restore them to avoid breaking on updates
      # Info: Restores migrations for versions between v0.7.1.4 and v0.7.9
      # On update: check if more migrations need to be restored!
      # Migrations should at least allow updates from previous NixOS versions
      ./restore-migrations.diff
      # Our nixos test depends on /api/locale; this patch fixes an upstream bug where the first response always fails
      # https://github.com/Kareadita/Kavita/pull/3686 remove once upstream is fixed
      (fetchpatch2 {
        name = "fix-locale-cache.patch";
        url = "https://github.com/Kareadita/Kavita/commit/5af07b9525c2164a6548092244bbdf66815b3e95.patch?full_index=1";
        hash = "sha256-aFZRxijAbA2mXJM+3kC4P4p76d0p5fEXLiaRhNmjOAA=";
      })
    ];
    postPatch = ''
      substituteInPlace API/Services/DirectoryService.cs --subst-var out

      substituteInPlace API/Startup.cs API/Services/LocalizationService.cs API/Controllers/FallbackController.cs \
        --subst-var-by webroot "${finalAttrs.frontend}/lib/node_modules/kavita-webui/dist/browser"
    '';

    executables = [ "API" ];

    projectFile = "API/API.csproj";
    nugetDeps = ./nuget-deps.json;
    dotnet-sdk = dotnetCorePackages.sdk_9_0;
    dotnet-runtime = dotnetCorePackages.aspnetcore_9_0;
  };

  frontend = buildNpmPackage {
    pname = "kavita-frontend";
    inherit (finalAttrs) version src;

    sourceRoot = "${finalAttrs.src.name}/UI/Web";

    npmBuildScript = "prod";
    npmFlags = [ "--legacy-peer-deps" ];
    npmRebuildFlags = [ "--ignore-scripts" ]; # Prevent playwright from trying to install browsers
    npmDepsHash = "sha256-9SfiH567+q3Id6/7pqWeX0y934V2YFQ4EWIJ+66smgI=";
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

  passthru = {
    tests = {
      inherit (nixosTests) kavita;
    };
    updateScript = ./update.sh;
  };

  meta = {
    description = "Fast, feature rich, cross platform reading server";
    homepage = "https://kavitareader.com";
    changelog = "https://github.com/kareadita/kavita/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      misterio77
      nevivurn
    ];
    mainProgram = "kavita";
  };
})
