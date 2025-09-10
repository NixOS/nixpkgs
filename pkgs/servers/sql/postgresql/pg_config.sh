#!@runtimeShell@
set -euo pipefail

# This replacement script for the pg_config binary is based on the original pg_config
# shell script, which was removed from PostgreSQL's codebase in 2004:
#   https://github.com/postgres/postgres/commit/cc07f8cfe73f56fce1ddda4ea25d7b0b6c4f0ae9
#
# The main reason for removal was the ability to relocate an existing installation, which
# is exactly the one feature that we are trying to work around in nixpkgs.
# Going back to a shell script is much better for cross compiling.
#
# This file is a combination of the following two files:
#   https://github.com/postgres/postgres/blob/7510ac6203bc8e3c56eae95466feaeebfc1b4f31/src/bin/pg_config/pg_config.sh
#   https://github.com/postgres/postgres/blob/master/src/bin/pg_config/pg_config.c

source @pg_config.env@

help="
pg_config provides information about the installed version of PostgreSQL.

Usage:
  pg_config [OPTION]...

Options:
  --bindir              show location of user executables
  --docdir              show location of documentation files
  --htmldir             show location of HTML documentation files
  --includedir          show location of C header files of the client
                        interfaces
  --pkgincludedir       show location of other C header files
  --includedir-server   show location of C header files for the server
  --libdir              show location of object code libraries
  --pkglibdir           show location of dynamically loadable modules
  --localedir           show location of locale support files
  --mandir              show location of manual pages
  --sharedir            show location of architecture-independent support files
  --sysconfdir          show location of system-wide configuration files
  --pgxs                show location of extension makefile
  --configure           show options given to \"configure\" script when
                        PostgreSQL was built
  --cc                  show CC value used when PostgreSQL was built
  --cppflags            show CPPFLAGS value used when PostgreSQL was built
  --cflags              show CFLAGS value used when PostgreSQL was built
  --cflags_sl           show CFLAGS_SL value used when PostgreSQL was built
  --ldflags             show LDFLAGS value used when PostgreSQL was built
  --ldflags_ex          show LDFLAGS_EX value used when PostgreSQL was built
  --ldflags_sl          show LDFLAGS_SL value used when PostgreSQL was built
  --libs                show LIBS value used when PostgreSQL was built
  --version             show the PostgreSQL version
  -?, --help            show this help, then exit

With no arguments, all known items are shown.

Report bugs to <${PACKAGE_BUGREPORT}>.
${PACKAGE_NAME} home page: <${PACKAGE_URL}>"

show=()

for opt; do
    case "$opt" in
        --bindir)               show+=("$PGBINDIR") ;;
        --docdir)               show+=("$DOCDIR") ;;
        --htmldir)              show+=("$HTMLDIR") ;;
        --includedir)           show+=("$INCLUDEDIR") ;;
        --pkgincludedir)        show+=("$PKGINCLUDEDIR") ;;
        --includedir-server)    show+=("$INCLUDEDIRSERVER") ;;
        --libdir)               show+=("$LIBDIR") ;;
        --pkglibdir)            show+=("$PKGLIBDIR") ;;
        --localedir)            show+=("$LOCALEDIR") ;;
        --mandir)               show+=("$MANDIR") ;;
        --sharedir)             show+=("$PGSHAREDIR") ;;
        --sysconfdir)           show+=("$SYSCONFDIR") ;;
        --pgxs)                 show+=("$PGXS") ;;
        --configure)            show+=("$CONFIGURE_ARGS") ;;
        --cc)                   show+=("$CC") ;;
        --cppflags)             show+=("$CPPFLAGS") ;;
        --cflags)               show+=("$CFLAGS") ;;
        --cflags_sl)            show+=("$CFLAGS_SL") ;;
        --ldflags)              show+=("$LDFLAGS") ;;
        --ldflags_ex)           show+=("$LDFLAGS_EX") ;;
        --ldflags_sl)           show+=("$LDFLAGS_SL") ;;
        --libs)                 show+=("$LIBS") ;;
        --version)              show+=("PostgreSQL $PG_VERSION") ;;
        --help|-\?)             echo "$help"
                                exit 0 ;;
        *)                      >&2 echo "pg_config: invalid argument: $opt"
                                >&2 echo "Try \"pg_config --help\" for more information."
                                exit 1 ;;
    esac
done

if [ ${#show[@]} -gt 0 ]; then
    printf '%s\n' "${show[@]}"
    exit 0
fi

# no arguments -> print everything
cat <<EOF
BINDIR = $PGBINDIR
DOCDIR = $DOCDIR
HTMLDIR = $HTMLDIR
INCLUDEDIR = $INCLUDEDIR
PKGINCLUDEDIR = $PKGINCLUDEDIR
INCLUDEDIR-SERVER = $INCLUDEDIRSERVER
LIBDIR = $LIBDIR
PKGLIBDIR = $PKGLIBDIR
LOCALEDIR = $LOCALEDIR
MANDIR = $MANDIR
SHAREDIR = $PGSHAREDIR
SYSCONFDIR = $SYSCONFDIR
PGXS = $PGXS
CONFIGURE = $CONFIGURE_ARGS
CC = $CC
CPPFLAGS = $CPPFLAGS
CFLAGS = $CFLAGS
CFLAGS_SL = $CFLAGS_SL
LDFLAGS = $LDFLAGS
LDFLAGS_EX = $LDFLAGS_EX
LDFLAGS_SL = $LDFLAGS_SL
LIBS = $LIBS
VERSION = PostgreSQL $PG_VERSION
EOF
