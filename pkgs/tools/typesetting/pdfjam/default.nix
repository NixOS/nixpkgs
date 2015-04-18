{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "pdfjam-${version}";
  version = "2.08";
  url-version = stdenv.lib.replaceChars ["."] [""] version;

  builder = ./builder.sh;

  src = fetchurl {
    url = "http://go.warwick.ac.uk/pdfjam/pdfjam_${url-version}.tgz";
    sha256 = "1wy0xhcy27d7agby598s20ba48s4yg5qkzr6anc6q1xdryccacf7";
  };

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.mornfall ];
  };
}
