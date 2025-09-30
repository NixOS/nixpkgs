{
  lib,
  stdenv,

  writableTmpDirAsHomeHook,
  cargo,
  fetchFromGitHub,
  fetchurl,
  installShellFiles,
  lame,
  mpv-unwrapped,
  ninja,
  callPackage,
  nixosTests,
  nodejs,
  jq,
  protobuf,
  python3,
  python3Packages,
  qt6,
  rsync,
  rustPlatform,
  uv,
  writeShellScriptBin,
  yarn,
  yarn-berry_4,

  swift,

  mesa,
}:

let
  yarn-berry = yarn-berry_4;

  pname = "anki";
  version = "25.07.5";
  rev = "7172b2d26684c7ef9d10e249bd43dc5bf73ae00c";

  srcHash = "sha256-nWxRr55Hm40V3Ijw+WetBKNoreLpcvRscgbOZa0REcY=";
  cargoHash = "sha256-H/xwPPL6VupSZGLPEThhoeMcg12FvAX3fmNM6zYfqRQ=";
  yarnHash = "sha256-adHnV345oDm20R8zGdEiEW+8/mTQAz4oxraybRfmwew=";
  pythonDeps = map (meta: {
    url = meta.url;
    path = toString (fetchurl meta);
  }) (lib.importJSON ./uv-deps.json);

  src = fetchFromGitHub {
    owner = "ankitects";
    repo = "anki";
    rev = version;
    hash = srcHash;
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = cargoHash;
  };

  # a wrapper for yarn to skip 'install'
  # We do this because we need to patchShebangs after install, so we do it
  # ourselves beforehand.
  # We also, confusingly, have to use yarn-berry to handle the lockfile (anki's
  # lockfile is too new for yarn), but have to use 'yarn' here, because anki's
  # build system uses yarn-1 style flags and such.
  # I think what's going on here is that yarn-1 in anki's normal build system
  # ends up noticing the yarn-file is too new and shelling out to yarn-berry
  # itself.
  noInstallYarn = writeShellScriptBin "yarn" ''
    [[ "$1" == "install" ]] && exit 0
    exec ${yarn}/bin/yarn "$@"
  '';

  uvWheels = stdenv.mkDerivation {
    name = "uv-wheels";
    phases = [ "installPhase" ];

    # otherwise, it's too long of a string
    passAsFile = [ "installCommand" ];
    installCommand = ''
      #!${stdenv.shell}
      mkdir -p $out
      # note: uv.lock doesn't contain build deps?? https://github.com/astral-sh/uv/issues/5190
      # link them in manually
      ln -vsf ${python3Packages.setuptools.dist}/*.whl $out
      ln -vsf ${python3Packages.editables.dist}/*.whl $out
      # we also force nixpkgs pyqt6 stuff because that needs to match the
      # nixpkgs qt6 version, otherwise we get linker errors
      ln -vsf ${python3Packages.pyqt6.dist}/*.whl $out
      ln -vsf ${python3Packages.pyqt6-webengine.dist}/*.whl $out
      ln -vsf ${python3Packages.pyqt6-sip.dist}/*.whl $out
    ''
    + (lib.strings.concatStringsSep "\n" (
      map (dep: ''
        if ! [[ "${builtins.baseNameOf dep.url}" =~ (PyQt|pyqt) ]]; then
          ln -vsf ${dep.path} "$out/${builtins.baseNameOf dep.url}"
        fi
      '') pythonDeps
    ));

    installPhase = ''bash $installCommandPath'';
  };
in

python3Packages.buildPythonApplication rec {
  format = "other";
  inherit pname version;

  outputs = [
    "out"
    "doc"
    "man"
    "lib"
  ];

  inherit src;

  patches = [
    ./patches/disable-auto-update.patch
    ./patches/remove-the-gl-library-workaround.patch
    ./patches/skip-formatting-python-code.patch
    ./patches/fix-compilation-under-rust-1.89.patch
    # Used in with-addons.nix
    ./patches/allow-setting-addons-folder.patch
  ];

  inherit cargoDeps;

  missingHashes = ./missing-hashes.json;
  yarnOfflineCache = yarn-berry.fetchYarnBerryDeps {
    inherit missingHashes;
    yarnLock = "${src}/yarn.lock";
    hash = yarnHash;
  };

  nativeBuildInputs = [
    uv
    cargo
    installShellFiles
    jq
    ninja
    nodejs
    qt6.wrapQtAppsHook
    rsync
    rustPlatform.cargoSetupHook
    writableTmpDirAsHomeHook
    yarn-berry_4.yarnBerryConfigHook
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin swift;

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux qt6.qtwayland;

  nativeCheckInputs = with python3Packages; [
    pytest
    mock
    astroid
  ];

  # tests fail with too many open files
  # TODO: verify if this is still true (I can't, no mac)
  doCheck = !stdenv.hostPlatform.isDarwin;

  checkFlags = [
    # this test is flaky, see https://github.com/ankitects/anki/issues/3619
    # also remove from anki-sync-server when removing this
    "--skip=deckconfig::update::test::should_keep_at_least_one_remaining_relearning_step"
  ];

  dontUseNinjaInstall = false;
  dontWrapQtApps = true;

  env = {
    # Activate optimizations
    RELEASE = true;

    # https://github.com/ankitects/anki/blob/24.11/docs/linux.md#packaging-considerations
    OFFLINE_BUILD = "1";
    NODE_BINARY = lib.getExe nodejs;
    PROTOC_BINARY = lib.getExe protobuf;
    PYTHON_BINARY = lib.getExe python3;
    UV_BINARY = lib.getExe uv;
    UV_NO_MANAGED_PYTHON = "1";
    UV_SYSTEM_PYTHON = true;
    UV_PYTHON_DOWNLOADS = "never";
    UV_OFFLINE = "1";
    UV_FIND_LINKS = "${uvWheels}";
  };

  buildPhase = ''
    export RUST_BACKTRACE=1
    export RUST_LOG=debug

    mkdir -p out/pylib/anki .git

    echo ${builtins.substring 0 8 rev} > out/buildhash
    echo ${python3.version} > .python-version

    # Setup the python environment.
    # We have 'UV_FIND_LINKS' set, so packages generally should just get picked
    # up, so install everything anki wants.
    # Note, for pyqt stuff, our versions may not match (see the comment above
    # uvWheels), so we don't install those.
    mkdir -p ./out/pyenv
    uv export > requirements.txt
    uv pip install --prefix ./out/pyenv -r requirements.txt
    uv export --project qt --extra qt --extra audio \
      --no-emit-package "pyqt6" \
      --no-emit-package "pyqt6-qt6" \
      --no-emit-package "pyqt6-webengine" \
      --no-emit-package "pyqt6-webengine-qt6" \
      --no-emit-package "pyqt6-sip" \
      > requirements.txt
    uv pip install --prefix ./out/pyenv -r requirements.txt
    uv export --project pylib > requirements.txt
    uv pip install --prefix ./out/pyenv -r requirements.txt

    # anki's build tooling expects python in there too
    ln -sf $PYTHON_BINARY ./out/pyenv/bin/python

    mv node_modules out

    # And finally build
    patchShebangs ./ninja

    export PYTHONPATH=$PYTHONPATH:$PWD/out/pyenv/${python3.sitePackages}
    # Necessary for yarn to not complain about 'corepack'
    jq 'del(.packageManager)' package.json > package.json.tmp && mv package.json.tmp package.json
    YARN_BINARY="${lib.getExe noInstallYarn}" PIP_USER=1 \
      ./ninja build wheels
  '';

  # mimic https://github.com/ankitects/anki/blob/76d8807315fcc2675e7fa44d9ddf3d4608efc487/build/ninja_gen/src/python.rs#L232-L250
  checkPhase =
    let
      disabledTestsString =
        lib.pipe
          [
            # assumes / is not writeable, somehow fails on nix-portable brwap
            "test_create_open"
          ]
          [
            (lib.map (test: "not ${test}"))
            (lib.concatStringsSep " and ")
            lib.escapeShellArg
          ];

    in
    ''
      runHook preCheck
      export PYTHONPATH=$PYTHONPATH:$PWD/out/pyenv/${python3.sitePackages}
      HOME=$TMP ANKI_TEST_MODE=1 PYTHONPATH=$PYTHONPATH:$PWD/out/pylib \
        pytest -p no:cacheprovider pylib/tests -k ${disabledTestsString}
      HOME=$TMP ANKI_TEST_MODE=1 PYTHONPATH=$PYTHONPATH:$PWD/out/pylib:$PWD/pylib:$PWD/out/qt \
        pytest -p no:cacheprovider qt/tests -k ${disabledTestsString}
      runHook postCheck
    '';

  installPhase = ''
    runHook preInstall

    mkdir -p $lib $out
    uv pip install out/wheels/*.whl --prefix $lib
    # remove non-anki bins from dependencies
    find $lib/bin -type f ! -name "anki*" -delete
    # and put bin into $out so people can access it. Leave $lib separate to avoid collisions, see
    # https://github.com/NixOS/nixpkgs/issues/438598
    mv $lib/bin $out/bin

    install -D -t $out/share/applications qt/launcher/lin/anki.desktop
    install -D -t $doc/share/doc/anki README* LICENSE*
    install -D -t $out/share/mime/packages qt/launcher/lin/anki.xml
    install -D -t $out/share/pixmaps qt/launcher/lin/anki.{png,xpm}
    installManPage qt/launcher/lin/anki.1

    runHook postInstall
  '';

  preFixup = ''
    makeWrapperArgs+=(
      "''${qtWrapperArgs[@]}"
      --prefix PATH ':' "${lame}/bin:${mpv-unwrapped}/bin"
      --prefix PYTHONPATH ':' "$lib/${python3.sitePackages}"
    )
  '';

  passthru = {
    withAddons = ankiAddons: callPackage ./with-addons.nix { inherit ankiAddons; };
    tests.anki-sync-server = nixosTests.anki-sync-server;
  };

  meta = with lib; {
    description = "Spaced repetition flashcard program";
    mainProgram = "anki";
    longDescription = ''
      Anki is a program which makes remembering things easy. Because it is a lot
      more efficient than traditional study methods, you can either greatly
      decrease your time spent studying, or greatly increase the amount you learn.

      Anyone who needs to remember things in their daily life can benefit from
      Anki. Since it is content-agnostic and supports images, audio, videos and
      scientific markup (via LaTeX), the possibilities are endless. For example:
      learning a language, studying for medical and law exams, memorizing
      people's names and faces, brushing up on geography, mastering long poems,
      or even practicing guitar chords!
    '';
    homepage = "https://apps.ankiweb.net";
    license = licenses.agpl3Plus;
    inherit (mesa.meta) platforms;
    maintainers = with maintainers; [
      euank
      junestepp
      oxij
    ];
    # Reported to crash at launch on darwin (as of 2.1.65)
    broken = stdenv.hostPlatform.isDarwin;
    badPlatforms = [
      # pyqt6-webengine is broken on darwin
      # https://github.com/NixOS/nixpkgs/issues/375059
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
