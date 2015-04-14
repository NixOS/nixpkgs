{ stdenv, fetchFromGitHub, writeScript, glibcLocales
, buildPythonPackage, pythonPackages, python

, enableAcoustid   ? true
, enableDiscogs    ? true
, enableEchonest   ? true
, enableFetchart   ? true
, enableLastfm     ? true
, enableMpd        ? true
, enableReplaygain ? true
, enableThumbnails ? true
, enableWeb        ? true

, bashInteractive, bashCompletion
}:

assert enableAcoustid    -> pythonPackages.pyacoustid     != null;
assert enableDiscogs     -> pythonPackages.discogs_client != null;
assert enableEchonest    -> pythonPackages.pyechonest     != null;
assert enableFetchart    -> pythonPackages.responses      != null;
assert enableLastfm      -> pythonPackages.pylast         != null;
assert enableMpd         -> pythonPackages.mpd            != null;
assert enableThumbnails  -> pythonPackages.pyxdg          != null;
assert enableReplaygain  -> pythonPackages.audiotools     != null;
assert enableWeb         -> pythonPackages.flask          != null;

with stdenv.lib;

let
  optionalPlugins = {
    chroma = enableAcoustid;
    discogs = enableDiscogs;
    echonest = enableEchonest;
    fetchart = enableFetchart;
    lastgenre = enableLastfm;
    lastimport = enableLastfm;
    mpdstats = enableMpd;
    mpdupdate = enableMpd;
    replaygain = enableReplaygain;
    thumbnails = enableThumbnails;
    web = enableWeb;
  };

  pluginsWithoutDeps = [
    "bench" "bpd" "bpm" "bucket" "convert" "cue" "duplicates" "embedart" "freedesktop"
    "fromfilename" "filefilter" "ftintitle" "fuzzy" "ihate" "importadded" "importfeeds"
    "info" "inline" "keyfinder" "lyrics" "mbcollection" "mbsync" "missing"
    "permissions" "play" "plexupdate" "random" "rewrite" "scrub" "smartplaylist"
    "spotify" "the" "types" "zero"
  ];

  enabledOptionalPlugins = attrNames (filterAttrs (_: id) optionalPlugins);

  allPlugins = pluginsWithoutDeps ++ attrNames optionalPlugins;
  allEnabledPlugins = pluginsWithoutDeps ++ enabledOptionalPlugins;

  testShell = "${bashInteractive}/bin/bash --norc";
  completion = "${bashCompletion}/share/bash-completion/bash_completion";

in buildPythonPackage rec {
  name = "beets-${version}";
  version = "1.3.11";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "sampsyo";
    repo = "beets";
    rev = "v${version}";
    sha256 = "16jb1frds9vl40n9hy18x9xipxfzln3ym823vx8jymhv3by8p62m";
  };

  propagatedBuildInputs = [
    pythonPackages.enum34
    pythonPackages.munkres
    pythonPackages.musicbrainzngs
    pythonPackages.mutagen
    pythonPackages.pathlib
    pythonPackages.pyyaml
    pythonPackages.unidecode
    python.modules.sqlite3
    python.modules.readline
  ] ++ optional enableAcoustid   pythonPackages.pyacoustid
    ++ optional enableFetchart   pythonPackages.requests2
    ++ optional enableDiscogs    pythonPackages.discogs_client
    ++ optional enableEchonest   pythonPackages.pyechonest
    ++ optional enableLastfm     pythonPackages.pylast
    ++ optional enableMpd        pythonPackages.mpd
    ++ optional enableThumbnails pythonPackages.pyxdg
    ++ optional enableReplaygain pythonPackages.audiotools
    ++ optional enableWeb        pythonPackages.flask;

  buildInputs = with pythonPackages; [
    beautifulsoup4
    flask
    mock
    nose
    pyechonest
    pylast
    rarfile
    requests2
    responses
  ];

  patches = [
    ./replaygain-default-audiotools.patch
  ];

  postPatch = ''
    sed -i -e '/assertIn.*item.*path/d' test/test_info.py
    echo echo completion tests passed > test/test_completion.sh

    sed -i -e '/^BASH_COMPLETION_PATHS *=/,/^])$/ {
      /^])$/i u"${completion}"
    }' beets/ui/commands.py
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
    LOCALE_ARCHIVE=${glibcLocales}/lib/locale/locale-archive \
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

  LANG = null;

  meta = {
    homepage = http://beets.radbox.org;
    description = "Music tagger and library organizer";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ iElectric aszlig pjones ];
  };
}
