{ stdenv, fetchurl
, sqlite, expat, spidermonkey, taglib, libexif, curl, ffmpeg, file }:

stdenv.mkDerivation rec {

  name = "mediatomb-${version}";
  version = "0.12.1";

  src = fetchurl {
    url = "mirror://sourceforge/mediatomb/${name}.tar.gz";
    sha256 = "1k8i5zvgik7cad7znd8358grzwh62frpqww1a5rwkldrlws3q5ii";
  };

  patches = [ ./zmm_new.patch ];

  buildInputs = [ sqlite expat spidermonkey taglib libexif curl ffmpeg file ];

  configureFlags = [ "--enable-inotify" ];

  meta = with stdenv.lib; {
    homepage = http://mediatomb.cc;
    description = "UPnP MediaServer with a web user interface";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.linux;
    broken = true;
  };
}
