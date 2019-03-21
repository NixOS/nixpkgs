# `configure` (maybe others) set `POSIXLY_CORRECT`, which
# breaks the gcc wrapper script of nixpkgs (maybe others).
# We simply un-export `POSIXLY_CORRECT` after each export so
# its effects don't apply within nixpkgs wrapper scripts.
grep -rlF POSIXLY_CORRECT | xargs \
  sed '/export *POSIXLY_CORRECT/a export -n POSIXLY_CORRECT' -i

# Replace strange default value for the nobody account.
if test -n "@maxuid@"
then
  for f in util/faxadduser.c hfaxd/manifest.h
  do
    substituteInPlace "$f" --replace 60002 "@maxuid@"
  done
fi

# Replace hardcoded `PATH` variables with proper paths.
# Note: `findutils` is needed for `faxcron`.
substituteInPlace faxcover/edit-faxcover.sh.in \
  --replace 'PATH=/bin' 'PATH="@faxcover_binpath@"'
substituteInPlace etc/faxsetup.sh.in \
  --replace 'PATH=/bin' 'PATH="@faxsetup_binpath@"'

# Create `config.site`
substitute "@configSite@" config.site --subst-var out
