{ lib
, stdenvNoCC
, fetchFromGitHub
, buildDotnetModule
, buildNpmPackage
, dotnetCorePackages
, nixosTests
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kavita";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "kareadita";
    repo = "kavita";
    # commit immediately following the v${version} tag
    # for correct version reporting
    rev = "44c046176e54fa81e3420a1a40dcd9871e0a45f1";
    hash = "sha256-cHX6nzajFqygdFF9y4KEAMv0tdNx9xFbpOoVNo8uafs=";
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
    ];
    postPatch = ''
      substituteInPlace API/Services/DirectoryService.cs --subst-var out

      substituteInPlace API/Startup.cs API/Services/LocalizationService.cs API/Controllers/FallbackController.cs \
        --subst-var-by webroot "${finalAttrs.frontend}/lib/node_modules/kavita-webui/dist/browser"
    '';

    executables = [ "API" ];

    projectFile = "API/API.csproj";
    nugetDeps = ./nuget-deps.nix;
    dotnet-sdk = dotnetCorePackages.sdk_8_0;
    dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;
  };

  frontend =  buildNpmPackage {
    pname = "kavita-frontend";
    inherit (finalAttrs) version src;

    sourceRoot = "${finalAttrs.src.name}/UI/Web";

    npmBuildScript = "prod";
    npmFlags = [ "--legacy-peer-deps" ];
    npmRebuildFlags = [ "--ignore-scripts" ]; # Prevent playwright from trying to install browsers
    npmDepsHash = "sha256-H53lwRr43MQWBbwc8N0GikAOkN2N0CwyiY8eGHveNFc=";
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
    tests = { inherit (nixosTests) kavita; };
    updateScript = ./update.sh;
  };

  meta = {
    description = "Fast, feature rich, cross platform reading server";
    homepage = "https://kavitareader.com";
    changelog = "https://github.com/kareadita/kavita/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ misterio77 nevivurn ];
    mainProgram = "kavita";
  };
})
