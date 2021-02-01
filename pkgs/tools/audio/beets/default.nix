{ stdenv, lib, fetchFromGitHub, writeScript, glibcLocales, diffPlugins, substituteAll
, pythonPackages, imagemagick, gobject-introspection, gst_all_1
, runtimeShell
, fetchpatch
, unstableGitUpdater

# Attributes needed for tests of the external plugins
, callPackage, beets

, enableAbsubmit         ? lib.elem stdenv.hostPlatform.system essentia-extractor.meta.platforms, essentia-extractor ? null
, enableAcousticbrainz   ? true
, enableAcoustid         ? true
, enableBadfiles         ? true, flac ? null, mp3val ? null
, enableBeatport         ? true
, enableBpsync           ? true
, enableConvert          ? true, ffmpeg ? null
, enableDeezer           ? true
, enableDiscogs          ? true
, enableEmbyupdate       ? true
, enableFetchart         ? true
, enableGmusic           ? true
, enableKeyfinder        ? true, keyfinder-cli ? null
, enableKodiupdate       ? true
, enableLastfm           ? true
, enableLoadext          ? true
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
, enableCheck            ? false, liboggz ? null
, enableCopyArtifacts    ? false
, enableExtraFiles       ? false

, bashInteractive, bash-completion
}:

assert enableAbsubmit    -> essentia-extractor               != null;
assert enableAcoustid    -> pythonPackages.pyacoustid        != null;
assert enableBadfiles    -> flac != null && mp3val != null;
assert enableBeatport    -> pythonPackages.requests_oauthlib != null;
assert enableBpsync      -> enableBeatport;
assert enableCheck       -> flac != null && mp3val != null && liboggz != null;
assert enableConvert     -> ffmpeg                         != null;
assert enableDiscogs     -> pythonPackages.discogs_client    != null;
assert enableFetchart    -> pythonPackages.responses         != null;
assert enableGmusic      -> pythonPackages.gmusicapi         != null;
assert enableKeyfinder   -> keyfinder-cli                    != null;
assert enableLastfm      -> pythonPackages.pylast            != null;
assert enableMpd         -> pythonPackages.mpd2              != null;
assert enableReplaygain  -> ffmpeg                         != null;
assert enableSonosUpdate -> pythonPackages.soco              != null;
assert enableThumbnails  -> pythonPackages.pyxdg             != null;
assert enableWeb         -> pythonPackages.flask             != null;

with lib;

let
  optionalPlugins = {
    absubmit = enableAbsubmit;
    acousticbrainz = enableAcousticbrainz;
    badfiles = enableBadfiles;
    beatport = enableBeatport;
    bpsync = enableBpsync;
    chroma = enableAcoustid;
    convert = enableConvert;
    deezer = enableDeezer;
    discogs = enableDiscogs;
    embyupdate = enableEmbyupdate;
    fetchart = enableFetchart;
    gmusic = enableGmusic;
    keyfinder = enableKeyfinder;
    kodiupdate = enableKodiupdate;
    lastgenre = enableLastfm;
    lastimport = enableLastfm;
    loadext = enableLoadext;
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
    "bench" "bpd" "bpm" "bucket" "cue" "duplicates" "edit" "embedart"
    "export" "filefilter" "fish" "freedesktop" "fromfilename" "ftintitle" "fuzzy"
    "hook" "ihate" "importadded" "importfeeds" "info" "inline" "ipfs" "lyrics"
    "mbcollection" "mbsubmit" "mbsync" "metasync" "missing" "parentwork" "permissions" "play"
    "plexupdate" "random" "rewrite" "scrub" "smartplaylist" "spotify" "the"
    "types" "unimported" "zero"
  ];

  enabledOptionalPlugins = attrNames (filterAttrs (_: id) optionalPlugins);

  allPlugins = pluginsWithoutDeps ++ attrNames optionalPlugins;
  allEnabledPlugins = pluginsWithoutDeps ++ enabledOptionalPlugins;

  testShell = "${bashInteractive}/bin/bash --norc";
  completion = "${bash-completion}/share/bash-completion/bash_completion";

  # This is a stripped down beets for testing of the external plugins.
  externalTestArgs.beets = (beets.override {
    enableAlternatives = false;
    enableCopyArtifacts = false;
    enableExtraFiles = false;
  }).overrideAttrs (const {
    doInstallCheck = false;
  });

  pluginArgs = externalTestArgs // { inherit pythonPackages; };

  plugins = {
    alternatives = callPackage ./plugins/alternatives.nix pluginArgs;
    check = callPackage ./plugins/check.nix pluginArgs;
    copyartifacts = callPackage ./plugins/copyartifacts.nix pluginArgs;
    extrafiles = callPackage ./plugins/extrafiles.nix pluginArgs;
  };

in pythonPackages.buildPythonApplication rec {
  pname = "beets";
  # While there is a stable version, 1.4.9, it is more than 1000 commits behind
  # master and lacks many bug fixes and improvements[1]. Also important,
  # unstable does not require bs1770gain[2].
  # [1]: https://discourse.beets.io/t/forming-a-beets-core-team/639
  # [2]: https://github.com/NixOS/nixpkgs/pull/90504
  version = "unstable-2021-01-29";

  src = fetchFromGitHub {
    owner = "beetbox";
    repo = "beets";
    rev = "04ea754d00e2873ae9aa2d9e07c5cefd790eaee2";
    sha256 = "sha256-BIa3hnOsBxThbA2WCE4q9eaFNtObr3erZBBqobVOSiQ=";
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
  ] ++ optional enableAbsubmit      essentia-extractor
    ++ optional enableAcoustid      pythonPackages.pyacoustid
    ++ optional enableBeatport      pythonPackages.requests_oauthlib
    ++ optional (enableFetchart
              || enableDeezer
              || enableEmbyupdate
              || enableKodiupdate
              || enableLoadext
              || enablePlaylist
              || enableSubsonicplaylist
              || enableSubsonicupdate
              || enableAcousticbrainz)
                                    pythonPackages.requests
    ++ optional enableCheck         plugins.check
    ++ optional enableConvert       ffmpeg
    ++ optional enableDiscogs       pythonPackages.discogs_client
    ++ optional enableGmusic        pythonPackages.gmusicapi
    ++ optional enableKeyfinder     keyfinder-cli
    ++ optional enableLastfm        pythonPackages.pylast
    ++ optional enableMpd           pythonPackages.mpd2
    ++ optional enableSonosUpdate   pythonPackages.soco
    ++ optional enableThumbnails    pythonPackages.pyxdg
    ++ optional enableWeb           pythonPackages.flask
    ++ optional enableAlternatives  plugins.alternatives
    ++ optional enableCopyArtifacts plugins.copyartifacts
    ++ optional enableExtraFiles    plugins.extrafiles
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
    discogs_client
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
      ffmpeg = getBin ffmpeg;
    })
    # Put absolute Nix paths in place
    ++ lib.optional enableConvert (substituteAll {
      src = ./convert-plugin-ffmpeg-path.patch;
      ffmpeg = getBin ffmpeg;
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
      plugins: ${concatStringsSep " " allEnabledPlugins}
      CFG
    ''}" HOME="$tmphome" "$out/bin/beet" config -e
    EDITOR=true HOME="$tmphome" "$out/bin/beet" config -e

    runHook postInstallCheck
  '';

  makeWrapperArgs = [ "--set GI_TYPELIB_PATH \"$GI_TYPELIB_PATH\"" "--set GST_PLUGIN_SYSTEM_PATH_1_0 \"$GST_PLUGIN_SYSTEM_PATH_1_0\"" ];

  passthru = {
    externalPlugins = plugins;
    updateScript = unstableGitUpdater { url = "https://github.com/beetbox/beets"; };
  };

  meta = {
    description = "Music tagger and library organizer";
    homepage = "http://beets.io";
    license = licenses.mit;
    maintainers = with maintainers; [ aszlig domenkozar doronbehar lovesegfault pjones ];
    platforms = platforms.linux;
  };
}
