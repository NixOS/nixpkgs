# The following is a check that patches don't get applied multiple times in the
# same manner that ct-ng does.

do_nix_patching() {
    # Check if already patched
    if [ -e "${CT_SRC_DIR}/.nix-patches.patched" ]; then
        CT_DoLog DEBUG "Already applied nix patching."
        return 0
    fi

    # Check if previously partially patched
    if [ -e "${CT_SRC_DIR}/.nix-patches.patching" ]; then
        CT_DoLog ERROR "Nix patches were partially applied."
        CT_DoLog ERROR "Please remove first:"
        CT_DoLog ERROR " - All source directories and .extracted files."
        CT_DoLog ERROR " - the .nix-patches.patching file'"
        CT_Abort "I'll stop now to avoid any carnage..."
    fi
    CT_DoExecLog DEBUG touch "${CT_SRC_DIR}/.nix-patches.patching"

    #Now we do the patching
    CT_DoLog EXTRA "Extra Nix patching"
    for f in $(find ${CT_WORK_DIR}/src -type f -name configure -o -name Makefile); do
        substituteInPlace $f --replace /bin/pwd pwd
    done

    CT_DoExecLog DEBUG touch "${CT_SRC_DIR}/.nix-patches.patched"
    CT_DoExecLog DEBUG rm -f "${CT_SRC_DIR}/.nix-patches.patching"
}
