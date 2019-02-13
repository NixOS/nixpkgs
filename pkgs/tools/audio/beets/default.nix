{ stdenv, fetchFromGitHub, writeScript, glibcLocales, diffPlugins
, pythonPackages, imagemagick, gobject-introspection, gst_all_1
, fetchpatch

# Attributes needed for tests of the external plugins
, callPackage, beets

, enableAcousticbrainz ? true
, enableAcoustid       ? true
, enableBadfiles       ? true, flac ? null, mp3val ? null
, enableConvert        ? true, ffmpeg ? null
, enableDiscogs        ? true
, enableEmbyupdate     ? true
, enableFetchart       ? true
, enableGmusic         ? true
, enableKeyfinder      ? true, keyfinder-cli ? null
, enableKodiupdate     ? true
, enableLastfm         ? true
, enableMpd            ? true
, enableReplaygain     ? true, bs1770gain ? null
, enableSonosUpdate    ? true
, enableThumbnails     ? true
, enableWeb            ? true

# External plugins
, enableAlternatives   ? false
, enableCopyArtifacts  ? false

, bashInteractive, bash-completion
}:

assert enableAcoustid    -> pythonPackages.pyacoustid     != null;
assert enableBadfiles    -> flac != null && mp3val != null;
assert enableConvert     -> ffmpeg != null;
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
    mpdstats = enableMpd;
    mpdupdate = enableMpd;
    replaygain = enableReplaygain;
    sonosupdate = enableSonosUpdate;
    thumbnails = enableThumbnails;
    web = enableWeb;
  };

  pluginsWithoutDeps = [
    "absubmit" "beatport" "bench" "bpd" "bpm" "bucket" "cue" "duplicates"
    "edit" "embedart" "export" "filefilter" "freedesktop" "fromfilename"
    "ftintitle" "fuzzy" "hook" "ihate" "importadded" "importfeeds" "info"
    "inline" "ipfs" "lyrics" "mbcollection" "mbsubmit" "mbsync" "metasync"
    "missing" "permissions" "play" "plexupdate" "random" "rewrite" "scrub"
    "smartplaylist" "spotify" "the" "types" "zero"
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
    copyartifacts = callPackage ./copyartifacts-plugin.nix pluginArgs;
  };

in pythonPackages.buildPythonApplication rec {
  pname = "beets";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "beetbox";
    repo = "beets";
    rev = "v${version}";
    sha256 = "17gfz0g7pqm6wha8zf63zpw07zgi787w1bjwdcxdh1l3z4m7jc9l";
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
  ] ++ optional enableAcoustid      pythonPackages.pyacoustid
    ++ optional (enableFetchart
              || enableEmbyupdate
              || enableKodiupdate
              || enableAcousticbrainz)
                                    pythonPackages.requests
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
    ++ optional enableCopyArtifacts plugins.copyartifacts;

  buildInputs = with pythonPackages; [
    beautifulsoup4
    imagemagick
    mock
    nose
    rarfile
    responses
  ] ++ (with gst_all_1; [
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
  ]);

  patches = [
    ./replaygain-default-bs1770gain.patch
    ./keyfinder-default-bin.patch

    # Fix Python 3.7 compatibility
    (fetchpatch {
      url = "https://github.com/beetbox/beets/commit/"
          + "15d44f02a391764da1ce1f239caef819f08beed8.patch";
      sha256 = "12rjb4959nvnrm3fvvki7chxjkipa0cy8i0yi132xrcn8141dnpm";
      excludes = [ "docs/changelog.rst" ];
    })
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
    sed -i -e 's,\(util\.command_output(\)\([^)]\+\)),\1[b"${ffmpeg.bin}/bin/ffmpeg" if args[0] == b"ffmpeg" else args[0]] + \2[1:]),' beetsplug/convert.py
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
    HOME="$(mktemp -d)" \
      # Exclude failing test https://github.com/beetbox/beets/issues/2652
      nosetests -v --exclude=test_single_month_nonmatch_ --exclude=test_asciify_variable --exclude=test_asciify_character_expanding_to_slash

    runHook postCheck
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    tmphome="$(mktemp -d)"

    EDITOR="${writeScript "beetconfig.sh" ''
      #!${stdenv.shell}
      cat > "$1" <<CFG
      plugins: ${concatStringsSep " " allEnabledPlugins}
      CFG
    ''}" HOME="$tmphome" "$out/bin/beet" config -e
    EDITOR=true HOME="$tmphome" "$out/bin/beet" config -e

    runHook postInstallCheck
  '';

  makeWrapperArgs = [ "--set GI_TYPELIB_PATH \"$GI_TYPELIB_PATH\"" "--set GST_PLUGIN_SYSTEM_PATH_1_0 \"$GST_PLUGIN_SYSTEM_PATH_1_0\"" ];

  meta = {
    description = "Music tagger and library organizer";
    homepage = http://beets.io;
    license = licenses.mit;
    maintainers = with maintainers; [ aszlig domenkozar pjones ];
    platforms = platforms.linux;
  };
}
