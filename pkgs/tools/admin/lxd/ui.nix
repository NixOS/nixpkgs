{ mkYarnPackage
, fetchFromGitHub
, fetchYarnDeps
, lib
}:

mkYarnPackage rec {
  pname = "lxd-ui";
  version = "unstable-2023-07-03";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "lxd-ui";
    rev = "c2e819a027d440cbb1cb9d450aad280dde68e231";
    sha256 = "sha256-lEzGACSv6CpxnfkOcsdPrH6KRKDkoKv63m8Gsodk8uc=";
  };

  packageJSON = ./package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    sha256 = "sha256-SLkgJDb9lwz/ShZh+H4YKAFRc1BdANWI5ndM2O6NzXE=";
  };

  buildPhase = ''
    yarn --offline build
  '';

  installPhase = ''
    cp -rv deps/lxd-ui/build/ui/ $out
  '';

  doDist = false;

  meta = {
    description = "Web user interface for LXD.";
    homepage = "https://linuxcontainers.org/lxd/";
    changelog = "https://github.com/canonical/lxd-ui";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
