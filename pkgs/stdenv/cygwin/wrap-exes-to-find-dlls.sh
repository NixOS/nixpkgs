postFixupHooks+=(_cygwinWrapExesToFindDlls)

_cygwinWrapExesToFindDlls() {
    find $out -type l | while read LINK; do
        TARGET="$(readlink "${LINK}")"

        # fix all non .exe links that link explicitly to a .exe
        if [[ ${TARGET} == *.exe ]] && [[ ${LINK} != *.exe ]]; then
            mv "${LINK}" "${LINK}.exe"
            LINK="${LINK}.exe"
        fi

        # generate complementary filenames
        if [[ ${LINK} == *.exe ]]; then
            _LINK="${LINK%.exe}"
            _TARGET="${TARGET%.exe}"
        else
            _LINK="${LINK}.exe"
            _TARGET="${TARGET}.exe"
        fi

        # check if sould create complementary link
        DOLINK=1
        if [[ ${_TARGET} == *.exe ]]; then
            # the canonical target has to be a .exe
            CTARGET="$(readlink -f "${LINK}")"
            if [[ ${CTARGET} != *.exe ]]; then
                CTARGET="${CTARGET}.exe"
            fi

            if [ ! -e "${CTARGET}" ]; then
                unset DOLINK
            fi
        fi

        if [ -e "${_LINK}" ]; then
            # complementary link seems to exist
            # but could be cygwin smoke and mirrors
            INO=$(stat -c%i "${LINK}")
            _INO=$(stat -c%i "${_LINK}")
            if [ "${INO}" -ne "${_INO}" ]; then
                unset DOLINK
            fi
        fi

        # create complementary link
        if [ -n "${DOLINK}" ]; then
            ln -s "${_TARGET}" "${_LINK}.tmp"
            mv "${_LINK}.tmp" "${_LINK}"
        fi
    done

    find $out -type f -name "*.exe" | while read EXE; do
        WRAPPER="${EXE%.exe}"
        if [ -e "${WRAPPER}" ]; then
            # check if really exists or cygwin smoke and mirrors
            INO=$(stat -c%i "${EXE}")
            _INO=$(stat -c%i "${WRAPPER}")
            if [ "${INO}" -ne "${_INO}" ]; then
                continue
            fi
        fi

        mv "${EXE}" "${EXE}.tmp"

        cat >"${WRAPPER}" <<EOF
#!/bin/sh
export PATH=$_PATH${_PATH:+:}\${PATH}
exec "\$0.exe" "\$@"
EOF
        chmod +x "${WRAPPER}"
        mv "${EXE}.tmp" "${EXE}"
    done
}
