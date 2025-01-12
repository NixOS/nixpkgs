set -euo pipefail

# The real pg_config needs to be in the same path as the "postgres" binary
# to return proper paths. However, we want it in the -dev output to prevent
# cyclic references and to prevent blowing up the runtime closure. Thus, we
# have wrapped -dev/bin/pg_config to fake its argv0 to be in the default
# output. Unfortunately, pg_config tries to be smart and tries to find itself -
# which will then fail with:
#   pg_config: could not find own program executable
# To counter this, we're creating *this* fake pg_config script and put it into
# the default output. The real pg_config is happy.
# Some extensions, e.g. timescaledb, use the reverse logic and look for pg_config
# in the same path as the "postgres" binary to support multi-version-installs.
# Thus, they will end up calling this script during build, even though the real
# pg_config would be available on PATH, provided by nativeBuildInputs. To help
# this case, we're redirecting the call to pg_config to the one found in PATH,
# iff we can be convinced that it belongs to our -dev output.

# Avoid infinite recursion
if [[ ! -v PG_CONFIG_CALLED ]]; then
    # compares "path of *this* script" with "path, which pg_config on PATH believes it is in"
    if [[ "$(readlink -f -- "$0")" == "$(PG_CONFIG_CALLED=1 pg_config --bindir)/pg_config" ]]; then
        # The pg_config in PATH returns the same bindir that we're actually called from.
        # This means that the pg_config in PATH is the one from "our" -dev output.
        # This happens when the -dev output has been put in native build
        # inputs and allows us to call the real pg_config without referencing
        # the -dev output itself.
        exec pg_config "$@"
    fi
fi

# This will happen in one of these cases:
# - *this* script is the first on PATH
# - np pg_config on PATH
# - some other pg_config on PATH, not from our -dev output
echo The real pg_config can be found in the -dev output.
exit 1
