{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "material-you-utilities";
  version = "2.0.14";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "material-you-utilities";
    tag = version;
    hash = "sha256-C2qNXQ/21zyXURjZuId+ANkhvjUCxqfATSW4hvU/9D4=";
  };

  npmDepsHash = "sha256-W9fKtN+Ux3Lzk4KtRPYM6B+1o8OtZ8ERkqdlT/PkXqA=";

  postPatch = ''
    # Remove git dependency from rspack config
    substituteInPlace rspack.config.js \
      --replace-fail "execSync('git branch --show-current').toString().trim() == 'main'" "false"
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/material-you-utilities.min.js $out/

    runHook postInstall
  '';

  passthru.entrypoint = "material-you-utilities.min.js";

  meta = {
    description = "Material Design 3 color theme generation and Home Assistant component modification";
    homepage = "https://github.com/Nerwyn/material-you-utilities";
    changelog = "https://github.com/Nerwyn/material-you-utilities/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
