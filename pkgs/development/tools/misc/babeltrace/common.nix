{ lib
, stdenv
, fetchzip
, autoreconfHook
, pkg-config
, glib
, elfutils

, version
, hash
}:

args: stdenv.mkDerivation (finalAttrs: args // {
  inherit version;

  src = fetchzip {
    url = "https://www.efficios.com/files/babeltrace/${finalAttrs.pname}-${finalAttrs.version}.tar.bz2";
    inherit hash;
  };

  # In 1.x, the pre-generated ./configure script uses an old autoconf version
  # which breaks cross-compilation (replaces references to malloc with
  # rpl_malloc).
  # In 2.x, there is no pre-generated ./configure script.
  # Re-generate with nixpkgs's autoconf. This requires glib to be present in
  # nativeBuildInputs for its m4 macros to be present.
  nativeBuildInputs = args.nativeBuildInputs or [ ] ++ [ autoreconfHook pkg-config glib ];

  buildInputs = args.buildInputs or [ ] ++ [ glib elfutils ];

  # --enable-debug-info (default) requires the configure script to run host
  # executables to determine the elfutils library version, which cannot be done
  # while cross compiling.
  configureFlags = args.configureFlags or [ ] ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "--disable-debug-info";

  meta = with lib; {
    description = "Command-line tool and library to read and convert LTTng tracefiles";
    homepage = "https://www.efficios.com/babeltrace";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
})
