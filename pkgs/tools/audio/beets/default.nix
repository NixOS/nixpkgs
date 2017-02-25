{ stdenv, fetchFromGitHub, writeScript, glibcLocales
, pythonPackages, imagemagick, gobjectIntrospection, gst_all_1

, enableAcousticbrainz ? true
, enableAcoustid       ? true
, enableBadfiles       ? true, flac ? null, mp3val ? null
, enableConvert        ? true, ffmpeg ? null
, enableDiscogs        ? true
, enableEmbyupdate     ? true
, enableFetchart       ? true
, enableKeyfinder      ? true, keyfinder-cli ? null
, enableLastfm         ? true
, enableMpd            ? true
, enableReplaygain     ? true, bs1770gain ? null
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
assert enableKeyfinder   -> keyfinder-cli != null;
assert enableLastfm      -> pythonPackages.pylast         != null;
assert enableMpd         -> pythonPackages.mpd            != null;
assert enableReplaygain  -> bs1770gain                    != null;
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
    keyfinder = enableKeyfinder;
    lastgenre = enableLastfm;
    lastimport = enableLastfm;
    mpdstats = enableMpd;
    mpdupdate = enableMpd;
    replaygain = enableReplaygain;
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

in pythonPackages.buildPythonApplication rec {
  name = "beets-${version}";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "beetbox";
    repo = "beets";
    rev = "v${version}";
    sha256 = "0sh2ap7jbqh7p8h63kgrx1ja9lyqlxjpfnh6axxw9p1mh78cgc1v";
  };

  propagatedBuildInputs = [
    pythonPackages.six
    pythonPackages.enum34
    pythonPackages.jellyfish
    pythonPackages.munkres
    pythonPackages.musicbrainzngs
    pythonPackages.mutagen
    pythonPackages.pathlib
    pythonPackages.pyyaml
    pythonPackages.unidecode
    pythonPackages.gst-python
    pythonPackages.pygobject3
    gobjectIntrospection
  ] ++ optional enableAcoustid     pythonPackages.pyacoustid
    ++ optional (enableFetchart
              || enableEmbyupdate
              || enableAcousticbrainz)
                                   pythonPackages.requests2
    ++ optional enableConvert      ffmpeg
    ++ optional enableDiscogs      pythonPackages.discogs_client
    ++ optional enableKeyfinder    keyfinder-cli
    ++ optional enableLastfm       pythonPackages.pylast
    ++ optional enableMpd          pythonPackages.mpd
    ++ optional enableThumbnails   pythonPackages.pyxdg
    ++ optional enableWeb          pythonPackages.flask
    ++ optional enableAlternatives (import ./alternatives-plugin.nix {
      inherit stdenv pythonPackages fetchFromGitHub;
    })
    ++ optional enableCopyArtifacts (import ./copyartifacts-plugin.nix {
      inherit stdenv pythonPackages fetchFromGitHub;
    });

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

  doCheck = true;

  preCheck = ''
    (${concatMapStrings (s: "echo \"${s}\";") allPlugins}) \
      | sort -u > plugins_defined
    find beetsplug -mindepth 1 \
      \! -path 'beetsplug/__init__.py' -a \
      \( -name '*.py' -o -path 'beetsplug/*/__init__.py' \) -print \
      | sed -n -re 's|^beetsplug/([^/.]+).*|\1|p' \
      | sort -u > plugins_available

    if ! mismatches="$(diff -y plugins_defined plugins_available)"; then
      echo "The the list of defined plugins (left side) doesn't match" \
           "the list of available plugins (right side):" >&2
      echo "$mismatches" >&2
      exit 1
    fi
  '';

  checkPhase = ''
    runHook preCheck

    LANG=en_US.UTF-8 \
    LOCALE_ARCHIVE=${assert stdenv.isLinux; glibcLocales}/lib/locale/locale-archive \
    BEETS_TEST_SHELL="${testShell}" \
    BASH_COMPLETION_SCRIPT="${completion}" \
    HOME="$(mktemp -d)" \
      nosetests -v

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
    homepage = http://beets.radbox.org;
    license = licenses.mit;
    maintainers = with maintainers; [ aszlig domenkozar pjones profpatsch ];
    platforms = platforms.linux;
  };
}
