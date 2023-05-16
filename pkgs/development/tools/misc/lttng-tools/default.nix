{ lib, stdenv, fetchurl, pkg-config, popt, libuuid, liburcu, lttng-ust, kmod, libxml2 }:

stdenv.mkDerivation rec {
  pname = "lttng-tools";
<<<<<<< HEAD
  version = "2.13.10";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-tools/${pname}-${version}.tar.bz2";
    sha256 = "sha256-5dEJXsEyJWXzjxSTRvcZZ0lsKB6sxR7Fx3mUuFDn0zU=";
=======
  version = "2.13.9";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-tools/${pname}-${version}.tar.bz2";
    sha256 = "sha256-jZTclbYIz3AhawEgOj+CQrl6Iy2y4jQhovQ3CNoI8zc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ popt libuuid liburcu lttng-ust libxml2 kmod ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Tracing tools (kernel + user space) for Linux";
    homepage = "https://lttng.org/";
    license = with licenses; [ lgpl21Only gpl2Only ];
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
