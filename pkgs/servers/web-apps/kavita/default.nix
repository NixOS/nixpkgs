{ lib
, stdenvNoCC
, fetchFromGitHub
, fetchpatch
, buildDotnetModule
, buildNpmPackage
, dotnetCorePackages
, nixosTests
, substituteAll
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kavita";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "kareadita";
    repo = "kavita";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Z8bGVF6h//37zz/J+PDlJhm7c9AUs2pgKhYY/4ELMhQ=";
  };

  backend = buildDotnetModule {
    pname = "kavita-backend";
    inherit (finalAttrs) version src;

    patches = [
      # Fix wrongly bumped version 0.8.0.10 -> 0.8.1
      # Remove on next release
      (fetchpatch {
        name = "fix-0.8.1-version.patch";
        url = "https://github.com/Kareadita/Kavita/commit/3c9565468ad5494aef11dace62ba4b18b0c7d7f3.patch";
        hash = "sha256-/dPHYrCeS6M82rw0lQ8K6C4jfXEvVVmjA85RKyVaxcE=";
      })
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
    npmDepsHash = "sha256-+RJ9mX/cIainO2xS/hIrIOShPVbHkhkCq6q2bP8dGKM=";
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
    description = "A fast, feature rich, cross platform reading server";
    homepage = "https://kavitareader.com";
    changelog = "https://github.com/kareadita/kavita/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ misterio77 nevivurn ];
    mainProgram = "kavita";
  };
})
