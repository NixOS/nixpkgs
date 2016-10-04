{ stdenv, fetchurl, gnutls, autoreconfHook, pkgconfig, libite, libconfuse }:

let
  version = "2.0";
in
stdenv.mkDerivation {
  name = "inadyn-${version}";

  src = fetchurl {
    url = "https://github.com/troglobit/inadyn/releases/download/v${version}/inadyn-${version}.tar.xz";
    sha256 = "16nmbxj337vkqkk6f7vx7fa8mczjv6dl3ybaxy16c23h486y0mzh";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ gnutls libite libconfuse ];

  meta = {
    homepage = http://inadyn.sourceforge.net/;
    description = "Free dynamic DNS client";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
