{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "ltunify-20140331";

  src = fetchgit {
    url = "https://git.lekensteyn.nl/ltunify.git";
    rev = "c3a263ff97bcd31e96abbfed33d066f8d2778f58";
    sha256 = "04g7mmljkx8643k53yd9x4k2ndrr98w7fbq10qn8ll6didkph3v8";
  };

  makeFlags = [ "DESTDIR=$(out)" "bindir=/bin" ];

  meta = with stdenv.lib; {
    description = "Tool for working with Logitech Unifying receivers and devices";
    homepage = https://lekensteyn.nl/logitech-unifying.html;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.abbradar ];
  };
}
