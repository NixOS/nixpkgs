{ lib
, stdenv

, buildEnv
, cargo
, fetchFromGitHub
, fetchYarnDeps
, installShellFiles
, lame
, mpv-unwrapped
, ninja
, nixosTests
, nodejs
, nodejs-slim
, prefetch-yarn-deps
, protobuf
, python3
, qt6
, rsync
, rustPlatform
, writeShellScriptBin
, yarn

, AVKit
, CoreAudio
, swift
}:

let
  pname = "anki";
  version = "23.12.1";
  rev = "1a1d4d5419c6b57ef3baf99c9d2d9cf85d36ae0a";

  src = fetchFromGitHub {
    owner = "ankitects";
    repo = "anki";
    rev = version;
    hash = "sha256-K38bhfU1076PxdKJFvnFb2w6Q9Q2MUmL+j8be3RZQYk=";
    fetchSubmodules = true;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "fsrs-0.1.0" = "sha256-KJgT01OmMbqgYFE5Fu8nblZl9rL5QVVMa2DNFsw6cdk=";
      "linkcheck-0.4.1" = "sha256-S93J1cDzMlzDjcvz/WABmv8CEC6x78E+f7nzhsN7NkE=";
      "percent-encoding-iri-2.2.0" = "sha256-kCBeS1PNExyJd4jWfDfctxq6iTdAq69jtxFQgCCQ8kQ=";
    };
  };
  cargoDeps = rustPlatform.importCargoLock cargoLock;

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-tOl+gLBE6SNPQvVWT/N7RKFaaP9SnpCBJf5dq2wCPuM=";
  };

  anki-build-python = python3.withPackages (ps: with ps; [
    mypy-protobuf
  ]);

  # anki shells out to git to check its revision, and also to update submodules
  # We don't actually need the submodules, so we stub that out
  fakeGit = writeShellScriptBin "git" ''
    case "$*" in
      "rev-parse --short=8 HEAD")
        echo ${builtins.substring 0 8 rev}
      ;;
      *"submodule update "*)
        exit 0
      ;;
      *)
        echo "Unrecognized git: $@"
        exit 1
      ;;
    esac
  '';

  # We don't want to run pip-sync, it does network-io
  fakePipSync = writeShellScriptBin "pip-sync" ''
    exit 0
  '';

  offlineYarn = writeShellScriptBin "yarn" ''
    [[ "$1" == "install" ]] && exit 0
    exec ${yarn}/bin/yarn --offline "$@"
  '';

  pyEnv = buildEnv {
    name = "anki-pyenv-${version}";
    paths = with python3.pkgs; [
      pip
      fakePipSync
      anki-build-python
    ];
    pathsToLink = [ "/bin" ];
  };

  # https://discourse.nixos.org/t/mkyarnpackage-lockfile-has-incorrect-entry/21586/3
  anki-nodemodules = stdenv.mkDerivation {
    pname = "anki-nodemodules";

    inherit version src yarnOfflineCache;

    nativeBuildInputs = [
      nodejs-slim
      prefetch-yarn-deps
      yarn
    ];

    configurePhase = ''
      export HOME=$NIX_BUILD_TOP
      yarn config --offline set yarn-offline-mirror $yarnOfflineCache
      fixup-yarn-lock yarn.lock
      yarn install --offline --frozen-lockfile --ignore-scripts --no-progress --non-interactive
      patchShebangs node_modules/
    '';

    installPhase = ''
      mv node_modules $out
    '';
  };
in
python3.pkgs.buildPythonApplication {
  inherit pname version;

  outputs = [ "out" "doc" "man" ];

  inherit src;

  patches = [
    ./patches/disable-auto-update.patch
    ./patches/remove-the-gl-library-workaround.patch
    ./patches/skip-formatting-python-code.patch
  ];

  inherit cargoDeps yarnOfflineCache;

  nativeBuildInputs = [
    fakeGit
    offlineYarn
    prefetch-yarn-deps

    cargo
    installShellFiles
    ninja
    qt6.wrapQtAppsHook
    rsync
    rustPlatform.cargoSetupHook
  ] ++ lib.optional stdenv.isDarwin swift;

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
  ] ++ lib.optional stdenv.isLinux qt6.qtwayland;

  propagatedBuildInputs = with python3.pkgs; [
    # This rather long list came from running:
    #    grep --no-filename -oE "^[^ =]*" python/{requirements.base.txt,requirements.bundle.txt,requirements.qt6_4.txt} | \
    #      sort | uniq | grep -v "^#$"
    # in their repo at the git tag for this version
    # There's probably a more elegant way, but the above extracted all the
    # names, without version numbers, of their python dependencies. The hope is
    # that nixpkgs versions are "close enough"
    # I then removed the ones the check phase failed on (pythonCatchConflictsPhase)
    beautifulsoup4
    certifi
    charset-normalizer
    click
    colorama
    decorator
    distro
    flask
    flask-cors
    idna
    importlib-metadata
    itsdangerous
    jinja2
    jsonschema
    markdown
    markupsafe
    orjson
    pep517
    pyparsing
    pyqt6
    pyqt6-sip
    pyqt6-webengine
    pyrsistent
    pysocks
    python3.pkgs.protobuf
    requests
    send2trash
    six
    soupsieve
    urllib3
    waitress
    werkzeug
    zipp
  ] ++ lib.optionals stdenv.isDarwin [
    AVKit
    CoreAudio
  ];

  nativeCheckInputs = with python3.pkgs; [ pytest mock astroid ];

  # tests fail with to many open files
  # TODO: verify if this is still true (I can't, no mac)
  doCheck = !stdenv.isDarwin;

  dontUseNinjaInstall = false;
  dontWrapQtApps = true;

  env = {
    # Activate optimizations
    RELEASE = true;

    NODE_BINARY = lib.getExe nodejs;
    PROTOC_BINARY = lib.getExe protobuf;
    PYTHON_BINARY = lib.getExe python3;
    YARN_BINARY = lib.getExe offlineYarn;
  };

  buildPhase = ''
    export RUST_BACKTRACE=1
    export RUST_LOG=debug

    mkdir -p out/pylib/anki .git

    echo ${builtins.substring 0 8 rev} > out/buildhash
    touch out/env
    touch .git/HEAD

    ln -vsf ${pyEnv} ./out/pyenv
    rsync --chmod +w -avP ${anki-nodemodules}/ out/node_modules/
    ln -vsf out/node_modules node_modules

    export HOME=$NIX_BUILD_TOP
    yarn config --offline set yarn-offline-mirror $yarnOfflineCache
    fixup-yarn-lock yarn.lock

    patchShebangs ./ninja
    PIP_USER=1 ./ninja build wheels
  '';

  # mimic https://github.com/ankitects/anki/blob/76d8807315fcc2675e7fa44d9ddf3d4608efc487/build/ninja_gen/src/python.rs#L232-L250
  checkPhase = ''
    HOME=$TMP ANKI_TEST_MODE=1 PYTHONPATH=$PYTHONPATH:$PWD/out/pylib \
      pytest -p no:cacheprovider pylib/tests
    HOME=$TMP ANKI_TEST_MODE=1 PYTHONPATH=$PYTHONPATH:$PWD/out/pylib:$PWD/pylib:$PWD/out/qt \
      pytest -p no:cacheprovider qt/tests
  '';

  preInstall = ''
    mkdir dist
    mv out/wheels/* dist
  '';

  postInstall = ''
    install -D -t $out/share/applications qt/bundle/lin/anki.desktop
    install -D -t $doc/share/doc/anki README* LICENSE*
    install -D -t $out/share/mime/packages qt/bundle/lin/anki.xml
    install -D -t $out/share/pixmaps qt/bundle/lin/anki.{png,xpm}
    installManPage qt/bundle/lin/anki.1
  '';

  preFixup = ''
    makeWrapperArgs+=(
      "''${qtWrapperArgs[@]}"
      --prefix PATH ':' "${lame}/bin:${mpv-unwrapped}/bin"
    )
  '';

  passthru = {
    # cargoLock is reused in anki-sync-server
    inherit cargoLock;
    tests.anki-sync-server = nixosTests.anki-sync-server;
  };

  meta = with lib; {
    description = "Spaced repetition flashcard program";
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
    platforms = platforms.mesaPlatforms;
    maintainers = with maintainers; [ euank oxij ];
    # Reported to crash at launch on darwin (as of 2.1.65)
    broken = stdenv.isDarwin;
  };
}
