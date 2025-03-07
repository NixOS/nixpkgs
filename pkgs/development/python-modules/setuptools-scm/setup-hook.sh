# Let built package know its version.
# Usually, when a package uses setuptools-scm as a build-time dependency, it
# expects to get the package version from SCM data. However, while doing a nix
# build, the source tree doesn't contain SCM data, so we should almost always
# get the version from the derivation attribute.
version-pretend-hook() {
    if [ -z "$dontPretendSetuptoolsSCMVersion" -a -z "$SETUPTOOLS_SCM_PRETEND_VERSION" ]; then
        echo Setting SETUPTOOLS_SCM_PRETEND_VERSION to $version
        export SETUPTOOLS_SCM_PRETEND_VERSION="$version"
    fi
}

# Include all tracked files.
# When a package uses setuptools-scm as a build-time dependency, it usually
# expects it to include all scm-tracked files in the built package, by default.
# This is the official setuptools-scm behavior, documented in
# https://setuptools-scm.readthedocs.io/en/latest/usage/#file-finders-hook-makes-most-of-manifestin-unnecessary
# and https://setuptools.pypa.io/en/latest/userguide/datafiles.html.
# However, while doing a nix build, the source tree doesn't contain SCM data,
# so it would include only `.py` files by default.
# We generate a MANIFEST.in automatically that includes all tracked files to
# emulate this behavior of setuptools-scm.
include-tracked-files-hook() {
    if [ -z "$dontIncludeSetuptoolsSCMTrackedFiles" ]; then
        echo Including all tracked files automatically
        old_manifest="$(if [ -f MANIFEST.in ]; then cat MANIFEST.in; fi)"
        echo 'global-include **' > MANIFEST.in
        echo "$old_manifest" >> MANIFEST.in
    fi
}

preBuildHooks+=(version-pretend-hook include-tracked-files-hook)
