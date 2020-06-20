{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libX11, libXrandr, glib, colord }:

stdenv.mkDerivation rec {
  pname = "xiccd";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "agalakhov";
    repo = "xiccd";
    rev = "v${version}";
    sha256 = "159fyz5535lcabi5bzmxgmjdgxlqcjaiqgzr00mi3ax0i5fdldwn";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libX11 libXrandr glib colord ];

  meta = with stdenv.lib; {
    description = "X color profile daemon";
    homepage = "https://github.com/agalakhov/xiccd";
    license = licenses.gpl3;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
  };
}
