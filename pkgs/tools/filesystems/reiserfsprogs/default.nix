<<<<<<< HEAD
{ lib, stdenv, fetchurl, libuuid, autoreconfHook, e2fsprogs, acl }:

stdenv.mkDerivation rec {
  pname = "reiserfsprogs";
  version = "3.6.27";

  src = fetchurl {
    url = "https://www.kernel.org/pub/linux/kernel/people/jeffm/reiserfsprogs/v${version}/${pname}-${version}.tar.xz";
    hash = "sha256-DpW2f6d0ajwtWRRem5wv60pr5ShT6DtJexgurlCOYuM=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libuuid e2fsprogs acl ];
=======
{ lib, stdenv, fetchurl, libuuid, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "reiserfsprogs";
  version = "3.6.24";

  src = fetchurl {
    url = "https://www.kernel.org/pub/linux/kernel/people/jeffm/reiserfsprogs/v${version}/${pname}-${version}.tar.xz";
    sha256 = "0q07df9wxxih8714a3mdp61h5n347l7j2a0l351acs3xapzgwi3y";
  };

  patches = [ ./reiserfsprogs-ar-fix.patch ];
  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libuuid ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  env.NIX_CFLAGS_COMPILE = toString [ "-std=gnu90" "-D_GNU_SOURCE" ];

  meta = {
    inherit version;
    homepage = "http://www.namesys.com/";
    description = "ReiserFS utilities";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
