{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "ltunify-20140331";

  src = fetchgit {
    url = "https://git.lekensteyn.nl/ltunify.git";
    rev = "c3a263ff97bcd31e96abbfed33d066f8d2778f58";
    sha256 = "0zjw064fl9f73ppl9c37wsfhp6296yx65m1gis2n2ia6arlnh45q";
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
