# This file is only used for shellcheck, not actually sourced via bash.
# The name of the file makes it, so that it can be included via directive like this:
#   # shellcheck source=stdenv.sh
#
# Shellcheck has rule SC2154 "var is referenced but not assigned":
#   https://www.shellcheck.net/wiki/SC2154
# Naturally, this rule is hard to validate for all our setup hooks, because they
# depend on variables:
#   - set in stdenv/generic/setup.sh
#   - set in default setup-hooks defined in stdenv/generic/default.nix (.../build-support/setup-hooks/...)
#   - passed as derivation arguments
#
# We can tell shellcheck about "dependencies" indirectly, with the following construct:
#   # shellcheck source=setup.sh
#   . /dev/null
# This will source /dev/null, so nothing. The shellcheck meta command will replace this
# with sourcing the generic/setup.sh file. Thus, all variables defined in stdenv will be
# known to shellcheck.

# All paths are relative to pkgs/stdenv/generic, thanks to .shellcheckrc.
# shellcheck source=setup.sh
. /dev/null
# shellcheck source=../../build-support/setup-hooks/audit-tmpdir.sh
. /dev/null
# shellcheck source=../../build-support/setup-hooks/compress-man-pages.sh
. /dev/null
# shellcheck source=../../build-support/setup-hooks/make-symlinks-relative.sh
. /dev/null
# shellcheck source=../../build-support/setup-hooks/move-docs.sh
. /dev/null
# shellcheck source=../../build-support/setup-hooks/move-lib64.sh
. /dev/null
# shellcheck source=../../build-support/setup-hooks/move-sbin.sh
. /dev/null
# shellcheck source=../../build-support/setup-hooks/move-systemd-user-units.sh
. /dev/null
# shellcheck source=../../build-support/setup-hooks/multiple-outputs.sh
. /dev/null
# shellcheck source=../../build-support/setup-hooks/patch-shebangs.sh
. /dev/null
# shellcheck source=../../build-support/setup-hooks/prune-libtool-files.sh
. /dev/null
# shellcheck source=../../build-support/setup-hooks/reproducible-builds.sh
. /dev/null
# shellcheck source=../../build-support/setup-hooks/set-source-date-epoch-to-latest.sh
. /dev/null
# shellcheck source=../../build-support/setup-hooks/strip.sh
. /dev/null

# We can't do the same for derivation arguments. We are left with the following choices:
#   - Putting shellcheck disable comments for that rule on each reference to a derivation argument.
#   - Disable the rule in a broader scope (per file / globally).
#   - "declare" the variables somewhere to have them be picked up by shellcheck.
#
# The last approach has the advantage that we don't need to miss out on the benefits of the rule, i.e.
# preventing spelling mistakes. More so, we get that check for those known derivation arguments as well.
# The best place to put those declaration is right in the file they are invented. Sometimes this might
# not be possible, in this case they can be redefined below.
#
# TLDR: The following code is **not** actually run by bash, only loaded by shellcheck.

# Note: Keeping this list nicely sorted will make it easier to prevent duplicates.
# ... nothing here, yet ...
