{
  lib,
  stdenv,
  src,
  version,
  fetchpatch,
  bashInteractive,
  diffPlugins,
  gobject-introspection,
  gst_all_1,
  python3Packages,
  sphinxHook,
  writableTmpDirAsHomeHook,
  runtimeShell,
  writeScript,

  # plugin deps, used indirectly by the @inputs when we `import ./builtin-plugins.nix`
  aacgain,
  chromaprint,
  essentia-extractor,
  ffmpeg,
  flac,
  imagemagick,
  keyfinder-cli,
  mp3gain,
  mp3val,

  extraPatches ? [ ],
  pluginOverrides ? { },
  disableAllPlugins ? false,
  disabledTests ? [ ],
  extraNativeBuildInputs ? [ ],

  # tests
  runCommand,
  beets,
}@inputs:
let
  inherit (lib) attrNames attrValues concatMap;

  mkPlugin =
    {
      name,
      enable ? !disableAllPlugins,
      builtin ? false,
      propagatedBuildInputs ? [ ],
      testPaths ? [
        "test/plugins/test_${name}.py"
      ],
      wrapperBins ? [ ],
    }:
    {
      inherit
        name
        enable
        builtin
        propagatedBuildInputs
        testPaths
        wrapperBins
        ;
    };

  basePlugins = lib.mapAttrs (_: a: { builtin = true; } // a) (import ./builtin-plugins.nix inputs);
  pluginOverrides' = lib.mapAttrs (
    plugName:
    lib.throwIf (basePlugins.${plugName}.deprecated or false)
      "beets evaluation error: Plugin ${plugName} was enabled in pluginOverrides, but it has been removed. Remove the override to fix evaluation."
  ) pluginOverrides;

  allPlugins = lib.mapAttrs (n: a: mkPlugin { name = n; } // a) (
    lib.recursiveUpdate basePlugins pluginOverrides'
  );
  builtinPlugins = lib.filterAttrs (_: p: p.builtin) allPlugins;
  enabledPlugins = lib.filterAttrs (_: p: p.enable) allPlugins;
  disabledPlugins = lib.filterAttrs (_: p: !p.enable) allPlugins;
  disabledTestPaths = lib.flatten (attrValues (lib.mapAttrs (_: v: v.testPaths) disabledPlugins));

  pluginWrapperBins = concatMap (p: p.wrapperBins) (attrValues enabledPlugins);
in
python3Packages.buildPythonApplication {
  pname = "beets";
  inherit src version;
  pyproject = true;

  patches = [
  ]
  ++ extraPatches;

  build-system = [
    python3Packages.poetry-core
    python3Packages.poetry-dynamic-versioning
  ];

  dependencies =
    with python3Packages;
    [
      confuse
      gst-python
      jellyfish
      mediafile
      munkres
      musicbrainzngs
      platformdirs
      pyyaml
      unidecode
      typing-extensions
      lap
    ]
    ++ (concatMap (p: p.propagatedBuildInputs) (attrValues enabledPlugins));

  nativeBuildInputs = [
    gobject-introspection
    sphinxHook
    python3Packages.pydata-sphinx-theme
    python3Packages.sphinx-design
    python3Packages.sphinx-copybutton
  ]
  ++ extraNativeBuildInputs;

  buildInputs = [
  ]
  ++ (with gst_all_1; [
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
  ]);

  outputs = [
    "out"
    "doc"
    "man"
  ];
  sphinxBuilders = [
    "html"
    "man"
  ];
  # Causes an installManPage error. Not clear why this directory gets generated
  # with the manpages. The same directory is observed correctly in
  # $doc/share/doc/beets-${version}/html
  preInstallSphinx = ''
    rm -r .sphinx/man/man/_sphinx_design_static
  '';

  postInstall = ''
    mkdir -p $out/share/zsh/site-functions
    cp extra/_beet $out/share/zsh/site-functions/
  '';

  makeWrapperArgs = [
    "--set GI_TYPELIB_PATH \"$GI_TYPELIB_PATH\""
    "--set GST_PLUGIN_SYSTEM_PATH_1_0 \"$GST_PLUGIN_SYSTEM_PATH_1_0\""
    "--prefix PATH : ${lib.makeBinPath pluginWrapperBins}"
  ];

  nativeCheckInputs =
    with python3Packages;
    [
      pytestCheckHook
      pytest-cov-stub
      mock
      rarfile
      responses
      requests-mock
      pillow
    ]
    ++ [
      writableTmpDirAsHomeHook
    ]
    ++ pluginWrapperBins;

  __darwinAllowLocalNetworking = true;

  disabledTestPaths =
    disabledTestPaths
    ++ [
      # touches network
      "test/plugins/test_aura.py"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Flaky: several tests fail randomly with:
      # if not self._poll(timeout):
      #   raise Empty
      #   _queue.Empty
      "test/plugins/test_bpd.py"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      # fail on Hydra with `RuntimeError: image cannot be obtained without artresizer backend`
      "test/plugins/test_art.py::AlbumArtOperationConfigurationTest::test_enforce_ratio"
      "test/plugins/test_art.py::AlbumArtOperationConfigurationTest::test_enforce_ratio_with_percent_margin"
      "test/plugins/test_art.py::AlbumArtOperationConfigurationTest::test_enforce_ratio_with_px_margin"
      "test/plugins/test_art.py::AlbumArtOperationConfigurationTest::test_minwidth"
      "test/plugins/test_art.py::AlbumArtPerformOperationTest::test_deinterlaced"
      "test/plugins/test_art.py::AlbumArtPerformOperationTest::test_deinterlaced_and_resized"
      "test/plugins/test_art.py::AlbumArtPerformOperationTest::test_file_not_resized"
      "test/plugins/test_art.py::AlbumArtPerformOperationTest::test_file_resized"
      "test/plugins/test_art.py::AlbumArtPerformOperationTest::test_file_resized_and_scaled"
      "test/plugins/test_art.py::AlbumArtPerformOperationTest::test_file_resized_but_not_scaled"
      "test/plugins/test_art.py::AlbumArtPerformOperationTest::test_resize"
    ];
  disabledTests = disabledTests ++ [
    # https://github.com/beetbox/beets/issues/5880
    "test_reject_different_art"
    # touches network
    "test_merge_duplicate_album"
  ];

  # Perform extra "sanity checks", before running pytest tests.
  preCheck = ''
    # Check for undefined plugins
    find beetsplug -mindepth 1 \
      \! -path 'beetsplug/__init__.py' -a \
      \( -name '*.py' -o -path 'beetsplug/*/__init__.py' \) -print \
      | sed -n -re 's|^beetsplug/([^/.]+).*|\1|p' \
      | sort -u > plugins_available
    ${diffPlugins (attrNames builtinPlugins) "plugins_available"}

    export BEETS_TEST_SHELL="${lib.getExe bashInteractive} --norc"

    env EDITOR="${writeScript "beetconfig.sh" ''
      #!${runtimeShell}
      cat > "$1" <<CFG
      plugins: ${lib.concatStringsSep " " (attrNames enabledPlugins)}
      CFG
    ''}" "$out/bin/beet" config -e
    env EDITOR=true "$out/bin/beet" config -e
  '';

  passthru.plugins = allPlugins;

  passthru.tests.gstreamer =
    runCommand "beets-gstreamer-test"
      {
        meta.timeout = 60;
      }
      ''
            set -euo pipefail
            export HOME=$(mktemp -d)
            mkdir $out

            cat << EOF > $out/config.yaml
        replaygain:
          backend: gstreamer
        EOF

            ${beets}/bin/beet -c $out/config.yaml > /dev/null
      '';

  meta = {
    description = "Music tagger and library organizer";
    homepage = "https://beets.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      aszlig
      doronbehar
      lovesegfault
      montchr
      pjones
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "beet";
  };
}
