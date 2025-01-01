{
  lib,
  adv_cmds,
  bmake,
  fetchFromGitHub,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "locale";
  version = "118";

  # This data is old, but it’s closer to what macOS has than FreeBSD. Trying to use the FreeBSD data
  # results in test failures due to different behavior (e.g., with zh_CN and spaces in gnulib’s `trim` test).
  # TODO(@reckenrode) Update locale data using https://cldr.unicode.org to match current macOS locale data.
  src = fetchFromGitHub {
    owner = "apple-oss-distributions";
    repo = "adv_cmds";
    rev = "adv_cmds-118";
    hash = "sha256-KzaAlqXqfJW2s31qmA0D7qteaZY57Va2o86aZrwyR74=";
  };

  sourceRoot = "source/usr-share-locale.tproj";

  postPatch = ''
    # bmake expects `Makefile` not `BSDmakefile`.
    find . -name Makefile -exec rm {} \; -exec ln -s BSDmakefile {} \;

    # Update `Makefile`s to: get commands from `PATH`, and install to the correct location.
    # Note: not every `Makefile` has `rsync` or the project name in it.
    for subproject in colldef mklocale monetdef msgdef numericdef timedef; do
      substituteInPlace "$subproject/BSDmakefile" \
        --replace-warn "../../$subproject.tproj/" "" \
        --replace-fail /usr/share/locale /share/locale \
        --replace-fail '-o ''${BINOWN} -g ''${BINGRP}' "" \
        --replace-warn "rsync -a" "cp -r"
    done

    # Update `bsdmake` references to `bmake`
    substituteInPlace Makefile \
      --replace-fail bsdmake bmake
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    adv_cmds
    bmake
  ];

  enableParallelInstalling = true;

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  meta = {
    description = "Locale data for Darwin";
    license = [
      lib.licenses.apsl10
      lib.licenses.apsl20
    ];
    maintainers = lib.teams.darwin.members;
  };
}
