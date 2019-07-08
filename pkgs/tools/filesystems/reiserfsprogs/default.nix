{ stdenv, fetchurl, libuuid, autoreconfHook }:

let version = "3.6.24"; in
stdenv.mkDerivation rec {
  name = "reiserfsprogs-${version}";

  src = fetchurl {
    url = "https://www.kernel.org/pub/linux/kernel/people/jeffm/reiserfsprogs/v${version}/${name}.tar.xz";
    sha256 = "0q07df9wxxih8714a3mdp61h5n347l7j2a0l351acs3xapzgwi3y";
  };

  patches = [ ./reiserfsprogs-ar-fix.patch ];
  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libuuid ];

  NIX_CFLAGS_COMPILE = "-std=gnu90";

  meta = {
    inherit version;
    homepage = http://www.namesys.com/;
    description = "ReiserFS utilities";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
