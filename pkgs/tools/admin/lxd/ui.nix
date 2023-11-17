{ mkYarnPackage
, fetchFromGitHub
, fetchYarnDeps
, lib
}:

mkYarnPackage rec {
  pname = "lxd-ui";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "lxd-ui";
    rev = "refs/tags/${version}";
    sha256 = "sha256-kbXJNT7mvEXfXQXKMWd0ZQBpXMhjvH3ae+c946SFWHk=";
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
