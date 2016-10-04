{ stdenv, fetchgit
, sqlite, expat, mp4v2, flac, spidermonkey, taglib, libexif, curl, ffmpeg, file
, pkgconfig, autoreconfHook }:

stdenv.mkDerivation rec {

  name = "mediatomb-${version}";
  version = "0.12.1";

  src = fetchgit {
    url = meta.repositories.git;
    rev = "7ab761696354868bd5d67ff4f2d849994e4c98e2";
    sha256 = "1mimslr4q6mky865y6561rr64cbn4gf0qc2dhgb31hxp4rc1kmzd";
  };

  buildInputs = [ sqlite expat spidermonkey taglib libexif curl ffmpeg file mp4v2 flac
                  pkgconfig autoreconfHook ];

  meta = with stdenv.lib; {
    homepage = http://mediatomb.cc;
    repositories.git = git://mediatomb.git.sourceforge.net/gitroot/mediatomb/mediatomb;
    description = "UPnP MediaServer with a web user interface";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.linux;
  };
}
