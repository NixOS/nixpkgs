{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libX11, libXrandr, glib, colord }:

stdenv.mkDerivation rec {
  name = "xiccd-${version}";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "agalakhov";
    repo = "xiccd";
    rev = "v${version}";
    sha256 = "0dhv913njzm80g5lwak5znmxllfa6rrkifwja8vk133lyxnarqra";
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
