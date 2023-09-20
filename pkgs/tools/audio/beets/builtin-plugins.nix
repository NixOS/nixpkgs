{ stdenv
, aacgain
, essentia-extractor
, ffmpeg
, flac
, imagemagick
, keyfinder-cli
, lib
, mp3gain
, mp3val
, python3Packages
, ...
}: {
  absubmit = {
    enable = lib.elem stdenv.hostPlatform.system essentia-extractor.meta.platforms;
    wrapperBins = [ essentia-extractor ];
  };
  acousticbrainz.propagatedBuildInputs = [ python3Packages.requests ];
  albumtypes = { };
  aura.propagatedBuildInputs = with python3Packages; [ flask pillow ];
  badfiles.wrapperBins = [ mp3val flac ];
  bareasc = { };
  beatport.propagatedBuildInputs = [ python3Packages.requests-oauthlib ];
  bench = { };
  bpd = { };
  bpm = { };
  bpsync = { };
  bucket = { };
  chroma.propagatedBuildInputs = [ python3Packages.pyacoustid ];
  convert.wrapperBins = [ ffmpeg ];
  deezer.propagatedBuildInputs = [ python3Packages.requests ];
  discogs.propagatedBuildInputs = with python3Packages; [ discogs-client requests ];
  duplicates = { };
  edit = { };
  embedart = {
    propagatedBuildInputs = with python3Packages; [ pillow ];
    wrapperBins = [ imagemagick ];
  };
  embyupdate.propagatedBuildInputs = [ python3Packages.requests ];
  export = { };
  fetchart = {
    propagatedBuildInputs = with python3Packages; [ requests pillow ];
    wrapperBins = [ imagemagick ];
  };
  filefilter = { };
  fish = { };
  freedesktop = { };
  fromfilename = { };
  ftintitle = { };
  fuzzy = { };
  gmusic = { };
  hook = { };
  ihate = { };
  importadded = { };
  importfeeds = { };
  info = { };
  inline = { };
  ipfs = { };
  keyfinder.wrapperBins = [ keyfinder-cli ];
  kodiupdate.propagatedBuildInputs = [ python3Packages.requests ];
  lastgenre.propagatedBuildInputs = [ python3Packages.pylast ];
  lastimport.propagatedBuildInputs = [ python3Packages.pylast ];
  loadext.propagatedBuildInputs = [ python3Packages.requests ];
  lyrics.propagatedBuildInputs = [ python3Packages.beautifulsoup4 ];
  mbcollection = { };
  mbsubmit = { };
  mbsync = { };
  metasync = { };
  missing = { };
  mpdstats.propagatedBuildInputs = [ python3Packages.mpd2 ];
  mpdupdate.propagatedBuildInputs = [ python3Packages.mpd2 ];
  parentwork = { };
  permissions = { };
  play = { };
  playlist.propagatedBuildInputs = [ python3Packages.requests ];
  plexupdate = { };
  random = { };
  replaygain.wrapperBins = [ aacgain ffmpeg mp3gain ];
  rewrite = { };
  scrub = { };
  smartplaylist = { };
  sonosupdate.propagatedBuildInputs = [ python3Packages.soco ];
  spotify = { };
  subsonicplaylist.propagatedBuildInputs = [ python3Packages.requests ];
  subsonicupdate.propagatedBuildInputs = [ python3Packages.requests ];
  the = { };
  thumbnails = {
    propagatedBuildInputs = with python3Packages; [ pillow pyxdg ];
    wrapperBins = [ imagemagick ];
  };
  types.testPaths = [ "test/test_types_plugin.py" ];
  unimported = { };
  web.propagatedBuildInputs = [ python3Packages.flask ];
  zero = { };
}
