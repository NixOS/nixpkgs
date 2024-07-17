{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  bison,
  flac,
  flex,
  id3v2,
  vorbis-tools,
}:

stdenv.mkDerivation rec {
  pname = "cuetools";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "svend";
    repo = pname;
    rev = version;
    sha256 = "02ksv1ahf1v4cr2xbclsfv5x17m9ivzbssb5r8xjm97yh8a7spa3";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    bison
    flac
    flex
    id3v2
    vorbis-tools
  ];

  postInstall = ''
    # add link for compatibility with Debian-based distros, which package `cuetag.sh` as `cuetag`
    ln -s $out/bin/cuetag.sh $out/bin/cuetag
  '';

  meta = with lib; {
    description = "A set of utilities for working with cue files and toc files";
    homepage = "https://github.com/svend/cuetools";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      codyopel
      jcumming
    ];
    platforms = platforms.all;
  };
}
