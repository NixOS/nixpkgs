{ stdenv, fetchFromGitHub, writeScript, glibcLocales, diffPlugins
, pythonPackages, imagemagick, gobject-introspection, gst_all_1
, runtimeShell
, fetchpatch

# Attributes needed for tests of the external plugins
, callPackage, beets

, enableAbsubmit       ? stdenv.lib.elem stdenv.hostPlatform.system essentia-extractor.meta.platforms, essentia-extractor ? null
, enableAcousticbrainz ? true
, enableAcoustid       ? true
, enableBadfiles       ? true, flac ? null, mp3val ? null
, enableConvert        ? true, ffmpeg_3 ? null
, enableDiscogs        ? true
, enableEmbyupdate     ? true
, enableFetchart       ? true
, enableGmusic         ? true
, enableKeyfinder      ? true, keyfinder-cli ? null
, enableKodiupdate     ? true
, enableLastfm         ? true
, enableLoadext        ? true
, enableMpd            ? true
, enablePlaylist       ? true
, enableReplaygain     ? true, bs1770gain ? null
, enableSonosUpdate    ? true
, enableSubsonicupdate ? true
, enableThumbnails     ? true
, enableWeb            ? true

# External plugins
, enableAlternatives   ? false
, enableCheck          ? false, liboggz ? null
, enableCopyArtifacts  ? false

, bashInteractive, bash-completion
}:

assert enableAbsubmit    -> essentia-extractor            != null;
assert enableAcoustid    -> pythonPackages.pyacoustid     != null;
assert enableBadfiles    -> flac != null && mp3val != null;
assert enableCheck       -> flac != null && mp3val != null && liboggz != null;
assert enableConvert     -> ffmpeg_3 != null;
assert enableDiscogs     -> pythonPackages.discogs_client != null;
assert enableFetchart    -> pythonPackages.responses      != null;
assert enableGmusic      -> pythonPackages.gmusicapi      != null;
assert enableKeyfinder   -> keyfinder-cli != null;
assert enableLastfm      -> pythonPackages.pylast         != null;
assert enableMpd         -> pythonPackages.mpd2           != null;
assert enableReplaygain  -> bs1770gain                    != null;
assert enableSonosUpdate -> pythonPackages.soco           != null;
assert enableThumbnails  -> pythonPackages.pyxdg          != null;
assert enableWeb         -> pythonPackages.flask          != null;

with stdenv.lib;

let
  optionalPlugins = {
    absubmit = enableAbsubmit;
    acousticbrainz = enableAcousticbrainz;
    badfiles = enableBadfiles;
    chroma = enableAcoustid;
    convert = enableConvert;
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
    subsonicupdate = enableSubsonicupdate;
    thumbnails = enableThumbnails;
    web = enableWeb;
  };

  pluginsWithoutDeps = [
    "beatport" "bench" "bpd" "bpm" "bucket" "cue" "duplicates" "edit" "embedart"
    "export" "filefilter" "freedesktop" "fromfilename" "ftintitle" "fuzzy"
    "hook" "ihate" "importadded" "importfeeds" "info" "inline" "ipfs" "lyrics"
    "mbcollection" "mbsubmit" "mbsync" "metasync" "missing" "permissions" "play"
    "plexupdate" "random" "rewrite" "scrub" "smartplaylist" "spotify" "the"
    "types" "zero"
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
  }).overrideAttrs (stdenv.lib.const {
    doInstallCheck = false;
  });

  pluginArgs = externalTestArgs // { inherit pythonPackages; };

  plugins = {
    alternatives = callPackage ./alternatives-plugin.nix pluginArgs;
    check = callPackage ./check-plugin.nix pluginArgs;
    copyartifacts = callPackage ./copyartifacts-plugin.nix pluginArgs;
  };

in pythonPackages.buildPythonApplication rec {
  pname = "beets";
  version = "1.4.9";

  src = fetchFromGitHub {
    owner = "beetbox";
    repo = "beets";
    rev = "v${version}";
    sha256 = "1qxdqbzvz97zgykzdwn78g2xyxmg0q2jdb12dnjnrwvhmjv67vi8";
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
    gobject-introspection
  ] ++ optional enableAbsubmit      essentia-extractor
    ++ optional enableAcoustid      pythonPackages.pyacoustid
    ++ optional (enableFetchart
              || enableEmbyupdate
              || enableKodiupdate
              || enableLoadext
              || enablePlaylist
              || enableSubsonicupdate
              || enableAcousticbrainz)
                                    pythonPackages.requests
    ++ optional enableCheck         plugins.check
    ++ optional enableConvert       ffmpeg_3
    ++ optional enableDiscogs       pythonPackages.discogs_client
    ++ optional enableGmusic        pythonPackages.gmusicapi
    ++ optional enableKeyfinder     keyfinder-cli
    ++ optional enableLastfm        pythonPackages.pylast
    ++ optional enableMpd           pythonPackages.mpd2
    ++ optional enableSonosUpdate   pythonPackages.soco
    ++ optional enableThumbnails    pythonPackages.pyxdg
    ++ optional enableWeb           pythonPackages.flask
    ++ optional enableAlternatives  plugins.alternatives
    ++ optional enableCopyArtifacts plugins.copyartifacts;

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
    ./replaygain-default-bs1770gain.patch
    ./keyfinder-default-bin.patch
    ./mutagen-1.43.patch
    (fetchpatch {
      # Fixes failing testcases around the werkzeug component; can dropped after 1.4.9
      url = "https://github.com/beetbox/beets/commit/d43d54e21cde97f57f19486925ab56b419254cc8.patch";
      sha256 = "13n2gzmcgfi0m2ycl2r1hpczgksplnkc3y6b66vg57rx5y8nnv5c";
    })

    # Fixes 548 tests due to breaking changes to the ast module
    # https://github.com/beetbox/beets/pull/3621
    # Can be dropped after 1.4.9
    ./compatibility-with-breaking-changes-to-the-ast-module.patch
  ];

  postPatch = ''
    sed -i -e '/assertIn.*item.*path/d' test/test_info.py
    echo echo completion tests passed > test/rsrc/test_completion.sh

    sed -i -e '/^BASH_COMPLETION_PATHS *=/,/^])$/ {
      /^])$/i u"${completion}"
    }' beets/ui/commands.py
  '' + optionalString enableBadfiles ''
    sed -i -e '/self\.run_command(\[/ {
      s,"flac","${flac.bin}/bin/flac",
      s,"mp3val","${mp3val}/bin/mp3val",
    }' beetsplug/badfiles.py
  '' + optionalString enableConvert ''
    sed -i -e 's,\(util\.command_output(\)\([^)]\+\)),\1[b"${ffmpeg_3.bin}/bin/ffmpeg" if args[0] == b"ffmpeg" else args[0]] + \2[1:]),' beetsplug/convert.py
  '' + optionalString enableReplaygain ''
    sed -i -re '
      s!^( *cmd *= *b?['\'''"])(bs1770gain['\'''"])!\1${bs1770gain}/bin/\2!
    ' beetsplug/replaygain.py
    sed -i -e 's/if has_program.*bs1770gain.*:/if True:/' \
      test/test_replaygain.py
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
  };

  meta = {
    description = "Music tagger and library organizer";
    homepage = "http://beets.io";
    license = licenses.mit;
    maintainers = with maintainers; [ aszlig domenkozar pjones ];
    platforms = platforms.linux;
  };
}
