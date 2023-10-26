{ mkYarnPackage
, fetchFromGitHub
, fetchYarnDeps
, lib
}:

mkYarnPackage rec {
  pname = "lxd-ui";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "lxd-ui";
    rev = "refs/tags/${version}";
    sha256 = "sha256-DygWNktangFlAqinBm6wWsRLGmX6yjhmRJ2iU0yjcgk=";
  };

  packageJSON = ./package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    sha256 = "sha256-B1SVCViX1LEFoBLMdFk9qaoayku7Y+zU5c4JEJkLmwE=";
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
    homepage = "https://github.com/canonical/lxd-ui";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
