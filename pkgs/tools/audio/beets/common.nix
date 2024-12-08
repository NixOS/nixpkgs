{
  lib,
  src,
  version,
  bashInteractive,
  diffPlugins,
  gobject-introspection,
  gst_all_1,
  python3Packages,
  sphinxHook,
  runtimeShell,
  writeScript,

  # plugin deps, used indirectly by the @inputs when we `import ./builtin-plugins.nix`
  aacgain,
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

  patches = extraPatches;

  build-system = [
    python3Packages.poetry-core
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
    ]
    ++ (concatMap (p: p.propagatedBuildInputs) (attrValues enabledPlugins));

  nativeBuildInputs = [
    gobject-introspection
    sphinxHook
    python3Packages.pydata-sphinx-theme
  ] ++ extraNativeBuildInputs;

  buildInputs =
    [
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
      pytest-cov
      mock
      rarfile
      responses
    ]
    ++ pluginWrapperBins;

  __darwinAllowLocalNetworking = true;

  disabledTestPaths = disabledTestPaths ++ [
    # touches network
    "test/plugins/test_aura.py"
  ];
  disabledTests = disabledTests ++ [
    # beets.ui.UserError: unknown command 'autobpm'
    "test/plugins/test_autobpm.py::TestAutoBPMPlugin::test_import"
    # AssertionError: assert 0 == 117
    "test/plugins/test_autobpm.py::TestAutoBPMPlugin::test_command"
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

    export BEETS_TEST_SHELL="${bashInteractive}/bin/bash --norc"
    export HOME="$(mktemp -d)"

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
