{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libX11, libXrandr, glib, colord }:

stdenv.mkDerivation rec {
  name = "xiccd-${version}";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "agalakhov";
    repo = "xiccd";
    rev = "v${version}";
    sha256 = "17p3vngmmjk52r5p8y41s19nwp7w25bgff68ffd50zdlicd33rsy";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libX11 libXrandr glib colord ];

  meta = with stdenv.lib; {
    description = "X color profile daemon";
    homepage = https://github.com/agalakhov/xiccd;
    license = licenses.gpl3;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
  };
}
