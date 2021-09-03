{ stdenv, lib, fetchFromGitHub, writeScript, glibcLocales, diffPlugins, substituteAll
, pythonPackages, imagemagick, gobject-introspection, gst_all_1
, runtimeShell, unstableGitUpdater

# external plugins package set
, beetsExternalPlugins

, enableAbsubmit         ? lib.elem stdenv.hostPlatform.system essentia-extractor.meta.platforms, essentia-extractor
, enableAcousticbrainz   ? true
, enableAcoustid         ? true
, enableAura             ? true
, enableBadfiles         ? true, flac, mp3val
, enableBeatport         ? true
, enableBpsync           ? true
, enableConvert          ? true, ffmpeg
, enableDeezer           ? true
, enableDiscogs          ? true
, enableEmbyupdate       ? true
, enableFetchart         ? true
, enableKeyfinder        ? true, keyfinder-cli
, enableKodiupdate       ? true
, enableLastfm           ? true
, enableLoadext          ? true
, enableLyrics           ? true
, enableMpd              ? true
, enablePlaylist         ? true
, enableReplaygain       ? true
, enableSonosUpdate      ? true
, enableSubsonicplaylist ? true
, enableSubsonicupdate   ? true
, enableThumbnails       ? true
, enableWeb              ? true

# External plugins
, enableAlternatives     ? false
, enableCopyArtifacts    ? false
, enableExtraFiles       ? false

, bashInteractive, bash-completion
}:

assert enableBpsync      -> enableBeatport;

let
  optionalPlugins = {
    absubmit = enableAbsubmit;
    acousticbrainz = enableAcousticbrainz;
    aura = enableAura;
    badfiles = enableBadfiles;
    beatport = enableBeatport;
    bpsync = enableBpsync;
    chroma = enableAcoustid;
    convert = enableConvert;
    deezer = enableDeezer;
    discogs = enableDiscogs;
    embyupdate = enableEmbyupdate;
    fetchart = enableFetchart;
    keyfinder = enableKeyfinder;
    kodiupdate = enableKodiupdate;
    lastgenre = enableLastfm;
    lastimport = enableLastfm;
    loadext = enableLoadext;
    lyrics = enableLyrics;
    mpdstats = enableMpd;
    mpdupdate = enableMpd;
    playlist = enablePlaylist;
    replaygain = enableReplaygain;
    sonosupdate = enableSonosUpdate;
    subsonicplaylist = enableSubsonicplaylist;
    subsonicupdate = enableSubsonicupdate;
    thumbnails = enableThumbnails;
    web = enableWeb;
  };

  pluginsWithoutDeps = [
    "bareasc" "bench" "bpd" "bpm" "bucket" "duplicates" "edit" "embedart"
    "export" "filefilter" "fish" "freedesktop" "fromfilename" "ftintitle" "fuzzy"
    "hook" "ihate" "importadded" "importfeeds" "info" "inline" "ipfs"
    "mbcollection" "mbsubmit" "mbsync" "metasync" "missing" "parentwork" "permissions" "play"
    "plexupdate" "random" "rewrite" "scrub" "smartplaylist" "spotify" "the"
    "types" "unimported" "zero"
  ];

  enabledOptionalPlugins = lib.attrNames (lib.filterAttrs (_: lib.id) optionalPlugins);

  allPlugins = pluginsWithoutDeps ++ lib.attrNames optionalPlugins;
  allEnabledPlugins = pluginsWithoutDeps ++ enabledOptionalPlugins;

  testShell = "${bashInteractive}/bin/bash --norc";
  completion = "${bash-completion}/share/bash-completion/bash_completion";

  # This is a stripped down beets for testing of the external plugins.
  externalTestArgs.beets = (lib.beets.override {
    enableAlternatives = false;
    enableCopyArtifacts = false;
    enableExtraFiles = false;
  }).overrideAttrs (lib.const {
    doInstallCheck = false;
  });

in pythonPackages.buildPythonApplication rec {
  pname = "beets";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "beetbox";
    repo = "beets";
    rev = "v${version}";
    sha256 = "sha256-yQMCJUwpjDDhPffBS6LUq6z4iT1VyFQE0R27XEbYXbY=";
  };

  propagatedBuildInputs = [
    pythonPackages.six
    pythonPackages.enum34
    pythonPackages.jellyfish
    pythonPackages.munkres
    pythonPackages.musicbrainzngs
    pythonPackages.mutagen
    pythonPackages.pyyaml
    pythonPackages.unidecode
    pythonPackages.gst-python
    pythonPackages.pygobject3
    pythonPackages.reflink
    pythonPackages.confuse
    pythonPackages.mediafile
    gobject-introspection
  ] ++ lib.optional enableAbsubmit         essentia-extractor
    ++ lib.optional enableAcoustid         pythonPackages.pyacoustid
    ++ lib.optional enableBeatport         pythonPackages.requests_oauthlib
    ++ lib.optional enableConvert          ffmpeg
    ++ lib.optional enableDiscogs          pythonPackages.discogs-client
    ++ lib.optional (enableFetchart
                  || enableDeezer
                  || enableEmbyupdate
                  || enableKodiupdate
                  || enableLoadext
                  || enablePlaylist
                  || enableSubsonicplaylist
                  || enableSubsonicupdate
                  || enableAcousticbrainz) pythonPackages.requests
    ++ lib.optional enableKeyfinder        keyfinder-cli
    ++ lib.optional enableLastfm           pythonPackages.pylast
    ++ lib.optional enableLyrics           pythonPackages.beautifulsoup4
    ++ lib.optional enableMpd              pythonPackages.mpd2
    ++ lib.optional enableSonosUpdate      pythonPackages.soco
    ++ lib.optional enableThumbnails       pythonPackages.pyxdg
    ++ lib.optional (enableAura
                  || enableWeb)            pythonPackages.flask
    ++ lib.optional enableAlternatives     beetsExternalPlugins.alternatives
    ++ lib.optional enableCopyArtifacts    beetsExternalPlugins.copyartifacts
    ++ lib.optional enableExtraFiles       beetsExternalPlugins.extrafiles
  ;

  buildInputs = [
    imagemagick
  ] ++ (with gst_all_1; [
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
  ]);

  checkInputs = with pythonPackages; [
    beautifulsoup4
    mock
    nose
    rarfile
    responses
    # Although considered as plugin dependencies, they are needed for the
    # tests, for disabling them via an override makes the build fail. see:
    # https://github.com/beetbox/beets/blob/v1.4.9/setup.py
    pylast
    mpd2
    discogs-client
    pyxdg
  ];

  patches = [
    # Bash completion fix for Nix
    ./bash-completion-always-print.patch
    # From some reason upstream assumes the program 'keyfinder-cli' is located
    # in the path as `KeyFinder`
    ./keyfinder-default-bin.patch
  ]
    # We need to force ffmpeg as the default, since we do not package
    # bs1770gain, and set the absolute path there, to avoid impurities.
    ++ lib.optional enableReplaygain (substituteAll {
      src = ./replaygain-default-ffmpeg.patch;
      ffmpeg = lib.getBin ffmpeg;
    })
    # Put absolute Nix paths in place
    ++ lib.optional enableConvert (substituteAll {
      src = ./convert-plugin-ffmpeg-path.patch;
      ffmpeg = lib.getBin ffmpeg;
    })
    ++ lib.optional enableBadfiles (substituteAll {
      src = ./badfiles-plugin-nix-paths.patch;
      inherit mp3val flac;
    })
  ;

  # Disable failing tests
  postPatch = ''
    sed -i -e '/assertIn.*item.*path/d' test/test_info.py
    echo echo completion tests passed > test/rsrc/test_completion.sh

    sed -i -e 's/len(mf.images)/0/' test/test_zero.py

    # Google Play Music was discontinued
    rm -r beetsplug/gmusic.py
  '';

  postInstall = ''
    mkdir -p $out/share/zsh/site-functions
    cp extra/_beet $out/share/zsh/site-functions/
  '';

  doCheck = true;

  preCheck = ''
    find beetsplug -mindepth 1 \
      \! -path 'beetsplug/__init__.py' -a \
      \( -name '*.py' -o -path 'beetsplug/*/__init__.py' \) -print \
      | sed -n -re 's|^beetsplug/([^/.]+).*|\1|p' \
      | sort -u > plugins_available

     ${diffPlugins allPlugins "plugins_available"}
  '';

  checkPhase = ''
    runHook preCheck

    LANG=en_US.UTF-8 \
    LOCALE_ARCHIVE=${assert stdenv.isLinux; glibcLocales}/lib/locale/locale-archive \
    BEETS_TEST_SHELL="${testShell}" \
    BASH_COMPLETION_SCRIPT="${completion}" \
    HOME="$(mktemp -d)" nosetests -v

    runHook postCheck
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    tmphome="$(mktemp -d)"

    EDITOR="${writeScript "beetconfig.sh" ''
      #!${runtimeShell}
      cat > "$1" <<CFG
      plugins: ${lib.concatStringsSep " " allEnabledPlugins}
      CFG
    ''}" HOME="$tmphome" "$out/bin/beet" config -e
    EDITOR=true HOME="$tmphome" "$out/bin/beet" config -e

    runHook postInstallCheck
  '';

  makeWrapperArgs = [ "--set GI_TYPELIB_PATH \"$GI_TYPELIB_PATH\"" "--set GST_PLUGIN_SYSTEM_PATH_1_0 \"$GST_PLUGIN_SYSTEM_PATH_1_0\"" ];

  passthru = {
    # FIXME: remove in favor of pkgs.beetsExternalPlugins
    externalPlugins = beetsExternalPlugins;
  };

  meta = with lib; {
    description = "Music tagger and library organizer";
    homepage = "https://beets.io";
    license = licenses.mit;
    maintainers = with maintainers; [ aszlig doronbehar lovesegfault pjones ];
    platforms = platforms.linux;
  };
}
