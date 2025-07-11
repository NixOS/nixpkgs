{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchurl,
}:

let
  # Upstream does not version control a lockfile:
  # <https://github.com/rianadon/opensprinkler-card/issues/25>
  # This lockfile comes from <https://github.com/rianadon/opensprinkler-card/pull/26>
  packageLockJson = fetchurl {
    url = "https://raw.githubusercontent.com/rianadon/opensprinkler-card/be4424d92b6edbda2418ecb7462dc4c3fb8b5d13/package-lock.json";
    hash = "sha256-sEH9D5g9WQ6+qDGYGCAXteeylBJLb4XVgTMPCUAY5qo=";
  };
in
buildNpmPackage (finalAttrs: {
  pname = "opensprinkler-card";
  version = "1.13";

  src = fetchFromGitHub {
    owner = "rianadon";
    repo = "opensprinkler-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Tz/8aj08DGv6gn2ssmCShF4RhmQmIkt02fjwDfYcd38=";
  };

  postPatch = ''
    ln -s ${packageLockJson} package-lock.json
  '';

  makeCacheWritable = true;

  npmDepsHash = "sha256-93Mju/9FGZ3cAgl1M/8j4Txjn33pzMjmer2Wn95/5yE=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    install -m0644 dist/opensprinkler-card.js $out

    runHook postInstall
  '';

  meta = {
    description = "Home Assistant card for collecting OpenSprinkler status";
    homepage = "https://github.com/rianadon/opensprinkler-card";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jfly ];
  };
})
