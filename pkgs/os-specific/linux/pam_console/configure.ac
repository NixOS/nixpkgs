AC_PREREQ([2.59])
AC_INIT([pam_console], [@PV@])
AM_INIT_AUTOMAKE([pam_console], [@PV@])

AC_CONFIG_HEADER([config.h])

AC_GNU_SOURCE

AM_CONDITIONAL([HAVE_VERSIONING], [test "x" = "y"])

PKG_CHECK_MODULES([GLIB], [glib-2.0])

m4_undefine([AC_PROG_CXX])
m4_defun([AC_PROG_CXX],[])
m4_undefine([AC_PROG_F77])
m4_defun([AC_PROG_F77],[])
AC_PROG_LIBTOOL

AC_PROG_YACC

SECUREDIR=${libdir}/security
SCONFIGDIR=${sysconfdir}/security

AC_SUBST([SECUREDIR])
AC_SUBST([SCONFIGDIR])

AC_OUTPUT([Makefile])
