# Everything that pg_config normally returns is put into pg_config.env, so
# that we can read it from our own pg_config script later on.
pg_config.env: $(top_builddir)/src/port/pg_config_paths.h | $(top_builddir)/src/include/pg_config.h
	echo "CC=\"$(CC)\"" >$@
	echo "CPPFLAGS=\"$(STD_CPPFLAGS)\"" >>$@
	echo "CFLAGS=\"$(CFLAGS)\"" >>$@
	echo "CFLAGS_SL=\"$(CFLAGS_SL)\"" >>$@
	echo "LDFLAGS=\"$(STD_LDFLAGS)\"" >>$@
	echo "LDFLAGS_EX=\"$(LDFLAGS_EX)\"" >>$@
	echo "LDFLAGS_SL=\"$(LDFLAGS_SL)\"" >>$@
	echo "LIBS=\"$(LIBS)\"" >>$@
	echo "PGXS=\"$(dev)/lib/pgxs/src/makefiles/pgxs.mk\"" >>$@
	cat $(top_builddir)/src/port/pg_config_paths.h $(top_builddir)/src/include/pg_config.h \
	  | sed -nE 's/^#define ([^ ]+) ("?)(.*)\2$$/\1="\3"/p' >>$@
