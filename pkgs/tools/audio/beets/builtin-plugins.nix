{
  aacgain,
  chromaprint,
  ffmpeg,
  flac,
  imagemagick,
  keyfinder-cli,
  mp3gain,
  mp3val,
  python3Packages,
  version,
  lib,
  ...
}:
{
  absubmit = {
    deprecated = true;
    testPaths = [ ];
  };
  advancedrewrite = {
    testPaths = [ ];
  };
  acousticbrainz = {
    deprecated = true;
    propagatedBuildInputs = [ python3Packages.requests ];
  };
  albumtypes = { };
  aura = {
    propagatedBuildInputs = with python3Packages; [
      flask
      flask-cors
      pillow
    ];
  };
  autobpm = {
    propagatedBuildInputs = with python3Packages; [
      librosa
      # An optional dependency of librosa, needed for beets' autobpm
      resampy
    ];
  };
  badfiles = {
    testPaths = [ ];
    wrapperBins = [
      mp3val
      flac
    ];
  };
  bareasc = { };
  beatport.propagatedBuildInputs = [ python3Packages.requests-oauthlib ];
  bench.testPaths = [ ];
  bpd.testPaths = [ ];
  bpm.testPaths = [ ];
  bpsync.testPaths = [ ];
  bucket = { };
  chroma = {
    propagatedBuildInputs = [ python3Packages.pyacoustid ];
    testPaths = [ ];
    wrapperBins = [
      chromaprint
    ];
  };
  convert.wrapperBins = [ ffmpeg ];
  deezer = {
    propagatedBuildInputs = [ python3Packages.requests ];
    testPaths = [ ];
  };
  discogs.propagatedBuildInputs = with python3Packages; [
    discogs-client
    requests
  ];
  duplicates.testPaths = [ ];
  edit = { };
  embedart = {
    propagatedBuildInputs = with python3Packages; [ pillow ];
    wrapperBins = [ imagemagick ];
  };
  embyupdate.propagatedBuildInputs = [ python3Packages.requests ];
  export = { };
  fetchart = {
    propagatedBuildInputs = with python3Packages; [
      beautifulsoup4
      langdetect
      pillow
      requests
    ];
    wrapperBins = [ imagemagick ];
  };
  filefilter = { };
  fish.testPaths = [ ];
  freedesktop.testPaths = [ ];
  fromfilename.testPaths = [ ];
  ftintitle = { };
  fuzzy.testPaths = [ ];
  gmusic.testPaths = [ ];
  hook = { };
  ihate = { };
  importadded = { };
  importfeeds = { };
  info = { };
  inline.testPaths = [ ];
  ipfs = { };
  keyfinder.wrapperBins = [ keyfinder-cli ];
  kodiupdate = {
    propagatedBuildInputs = [ python3Packages.requests ];
    testPaths = [ ];
  };
  lastgenre.propagatedBuildInputs = [ python3Packages.pylast ];
  lastimport = {
    propagatedBuildInputs = [ python3Packages.pylast ];
    testPaths = [ ];
  };
  limit = { };
  listenbrainz = {
    testPaths = [ ];
  };
  loadext = {
    propagatedBuildInputs = [ python3Packages.requests ];
    testPaths = [ ];
  };
  lyrics.propagatedBuildInputs = with python3Packages; [
    beautifulsoup4
    langdetect
    requests
  ];
  mbcollection.testPaths = [ ];
  mbsubmit = { };
  mbsync = { };
  metasync.testPaths = [ ];
  missing.testPaths = [ ];
  mpdstats.propagatedBuildInputs = [ python3Packages.mpd2 ];
  mpdupdate = {
    propagatedBuildInputs = [ python3Packages.mpd2 ];
    testPaths = [ ];
  };
  musicbrainz = { };
  parentwork = { };
  permissions = { };
  play = { };
  playlist.propagatedBuildInputs = [ python3Packages.requests ];
  plexupdate = { };
  random = { };
  replace = { };
  replaygain.wrapperBins = [
    aacgain
    ffmpeg
    mp3gain
  ];
  rewrite.testPaths = [ ];
  scrub.testPaths = [ ];
  smartplaylist = { };
  sonosupdate = {
    propagatedBuildInputs = [ python3Packages.soco ];
    testPaths = [ ];
  };
  spotify = { };
  subsonicplaylist = {
    propagatedBuildInputs = [ python3Packages.requests ];
    testPaths = [ ];
  };
  subsonicupdate.propagatedBuildInputs = [ python3Packages.requests ];
  substitute = {
    testPaths = [ ];
  };
  the = { };
  thumbnails = {
    propagatedBuildInputs = with python3Packages; [
      pillow
      pyxdg
    ];
    wrapperBins = [ imagemagick ];
  };
  types.testPaths = [ "test/plugins/test_types_plugin.py" ];
  unimported.testPaths = [ ];
  web.propagatedBuildInputs = with python3Packages; [
    flask
    flask-cors
  ];
  zero = { };
  _typing = {
    testPaths = [ ];
  };
}
