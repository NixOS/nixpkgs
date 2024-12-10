{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  glib,
  libuuid,
  popt,
  elfutils,
}:

stdenv.mkDerivation rec {
  pname = "babeltrace";
  version = "1.5.8";

  src = fetchurl {
    url = "https://www.efficios.com/files/babeltrace/${pname}-${version}.tar.bz2";
    sha256 = "1hkg3phnamxfrhwzmiiirbhdgckzfkqwhajl0lmr1wfps7j47wcz";
  };

  # The pre-generated ./configure script uses an old autoconf version which
  # breaks cross-compilation (replaces references to malloc with rpl_malloc).
  # Re-generate with nixpkgs's autoconf. This requires glib to be present in
  # nativeBuildInputs for its m4 macros to be present.
  nativeBuildInputs = [
    autoreconfHook
    glib
    pkg-config
  ];
  buildInputs = [
    glib
    libuuid
    popt
    elfutils
  ];

  # --enable-debug-info (default) requires the configure script to run host
  # executables to determine the elfutils library version, which cannot be done
  # while cross compiling.
  configureFlags = lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "--disable-debug-info";

  meta = with lib; {
    description = "Command-line tool and library to read and convert LTTng tracefiles";
    homepage = "https://www.efficios.com/babeltrace";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
