# Avoid using git to auto-bump the addon version
# DOCS https://github.com/sbidoul/whool/?tab=readme-ov-file#configuration
whool-post-version-strategy-hook() {
    # DOCS https://stackoverflow.com/a/13864829/1468388
    if [ -z ${WHOOL_POST_VERSION_STRATEGY_OVERRIDE+x} ]; then
        echo Setting WHOOL_POST_VERSION_STRATEGY_OVERRIDE to none
        export WHOOL_POST_VERSION_STRATEGY_OVERRIDE=none
    fi

    # Make sure you can import the built addon
    for manifest in $(find -L . -name __manifest__.py); do
        export pythonImportsCheck="$pythonImportsCheck odoo.addons.$(basename $(dirname $(realpath $manifest)))"
    done
}

preBuildHooks+=(whool-post-version-strategy-hook)
