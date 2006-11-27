# Create an etc/event.d directory containing symlinks to the
# specified list of Upstart job files.
{stdenv, jobs}:

stdenv.mkDerivation {
  name = "upstart-jobs";

  inherit jobs;

  builder = builtins.toFile "builder.sh" "
    source $stdenv/setup
    ensureDir $out/etc/event.d
    for i in $jobs; do
      if test -d $i; then
        ln -s $i/etc/event.d/* $out/etc/event.d/
      fi
    done
  ";
}
