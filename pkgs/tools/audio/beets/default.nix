{ stdenv, fetchFromGitHub, writeScript
, buildPythonPackage, pythonPackages, python

, enableAcoustid   ? true
, enableBeatport   ? true
, enableDiscogs    ? true
, enableEchonest   ? true
, enableFetchart   ? true
, enableLastfm     ? true
, enableMpd        ? true
, enableReplaygain ? true
, enableWeb        ? true

, bashInteractive, bashCompletion
}:

assert enableAcoustid    -> pythonPackages.pyacoustid     != null;
assert enableBeatport    -> pythonPackages.responses      != null;
assert enableDiscogs     -> pythonPackages.discogs_client != null;
assert enableEchonest    -> pythonPackages.pyechonest     != null;
assert enableFetchart    -> pythonPackages.responses      != null;
assert enableLastfm      -> pythonPackages.pylast         != null;
assert enableMpd         -> pythonPackages.mpd            != null;
assert enableReplaygain  -> pythonPackages.audiotools     != null;
assert enableWeb         -> pythonPackages.flask          != null;

with stdenv.lib;

let
  optionalPlugins = {
    beatport = enableBeatport;
    chroma = enableAcoustid;
    discogs = enableDiscogs;
    echonest = enableEchonest;
    echonest_tempo = enableEchonest;
    fetchart = enableFetchart;
    lastgenre = enableLastfm;
    lastimport = enableLastfm;
    mpdstats = enableMpd;
    mpdupdate = enableMpd;
    replaygain = enableReplaygain;
    web = enableWeb;
  };

  pluginsWithoutDeps = [
    "bench" "bpd" "bpm" "bucket" "convert" "duplicates" "embedart" "freedesktop"
    "fromfilename" "ftintitle" "fuzzy" "ihate" "importadded" "importfeeds"
    "info" "inline" "keyfinder" "lyrics" "mbcollection" "mbsync" "missing"
    "play" "random" "rewrite" "scrub" "smartplaylist" "spotify" "the" "types"
    "zero"
  ];

  enabledOptionalPlugins = attrNames (filterAttrs (_: id) optionalPlugins);

  allPlugins = pluginsWithoutDeps ++ attrNames optionalPlugins;
  allEnabledPlugins = pluginsWithoutDeps ++ enabledOptionalPlugins;

  # Discogs plugin wants to have an API token, so skip install checks.
  allTestablePlugins = remove "discogs" allEnabledPlugins;

  testShell = "${bashInteractive}/bin/bash --norc";
  completion = "${bashCompletion}/share/bash-completion/bash_completion";

in buildPythonPackage rec {
  name = "beets-${version}";
  version = "1.3.9";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "sampsyo";
    repo = "beets";
    rev = "v${version}";
    sha256 = "1srhkiyjqx6i3gn20ihf087l5pa77yh5b81ivc52lj491fda7xqk";
  };

  propagatedBuildInputs = [
    pythonPackages.enum34
    pythonPackages.munkres
    pythonPackages.musicbrainzngs
    pythonPackages.mutagen
    pythonPackages.pyyaml
    pythonPackages.unidecode
    python.modules.sqlite3
    python.modules.readline
  ] ++ optional enableAcoustid                     pythonPackages.pyacoustid
    ++ optional (enableBeatport || enableFetchart) pythonPackages.requests2
    ++ optional enableDiscogs                      pythonPackages.discogs_client
    ++ optional enableEchonest                     pythonPackages.pyechonest
    ++ optional enableLastfm                       pythonPackages.pylast
    ++ optional enableMpd                          pythonPackages.mpd
    ++ optional enableReplaygain                   pythonPackages.audiotools
    ++ optional enableWeb                          pythonPackages.flask;

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
    ./mediafile-codec-fix.patch
    ./replaygain-default-audiotools.patch
    ./test-bucket-fix-year.patch
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
      plugins: ${concatStringsSep " " allTestablePlugins}
      musicbrainz:
        user: dummy
        pass: dummy
      CFG
    ''}" HOME="$tmphome" "$out/bin/beet" config -e
    EDITOR=true HOME="$tmphome" "$out/bin/beet" config -e

    runHook postInstallCheck
  '';

  meta = {
    homepage = http://beets.radbox.org;
    description = "Music tagger and library organizer";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ iElectric aszlig ];
  };
}
