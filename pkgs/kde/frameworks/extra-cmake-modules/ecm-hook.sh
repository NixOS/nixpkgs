# shellcheck shell=bash
# Variables we use here are set by the stdenv, no use complaining about them
# shellcheck disable=SC2164

ecmEnvHook() {
    addToSearchPath XDG_DATA_DIRS "$1/share"
    addToSearchPath XDG_CONFIG_DIRS "$1/etc/xdg"
}
addEnvHooks "$hostOffset" ecmEnvHook

ecmPostHook() {
    # Because we need to use absolute paths here, we must set *all* the paths.
    # Keep this in sync with https://github.com/KDE/extra-cmake-modules/blob/master/kde-modules/KDEInstallDirs6.cmake
    if [ "$(uname)" = "Darwin" ]; then
        appendToVar cmakeFlags "-DKDE_INSTALL_BUNDLEDIR=${!outputBin}/Applications/KDE"
    fi

    appendToVar cmakeFlags "-DKDE_INSTALL_EXECROOTDIR=${!outputBin}"
    appendToVar cmakeFlags "-DKDE_INSTALL_BINDIR=${!outputBin}/bin"
    appendToVar cmakeFlags "-DKDE_INSTALL_SBINDIR=${!outputBin}/sbin"
    appendToVar cmakeFlags "-DKDE_INSTALL_LIBDIR=${!outputLib}/lib"
    appendToVar cmakeFlags "-DKDE_INSTALL_LIBEXECDIR=${!outputLib}/libexec"
    appendToVar cmakeFlags "-DKDE_INSTALL_CMAKEPACKAGEDIR=${!outputDev}/lib/cmake"

    if [ -n "${qtPluginPrefix-}" ]; then
        appendToVar cmakeFlags "-DKDE_INSTALL_QTPLUGINDIR=${!outputBin}/$qtPluginPrefix"
        appendToVar cmakeFlags "-DKDE_INSTALL_PLUGINDIR=${!outputBin}/$qtPluginPrefix"
    fi

    if [ -n "${qtQmlPrefix-}" ]; then
        appendToVar cmakeFlags "-DKDE_INSTALL_QMLDIR=${!outputBin}/$qtQmlPrefix"
    fi

    appendToVar cmakeFlags "-DKDE_INSTALL_INCLUDEDIR=${!outputInclude}/include"
    appendToVar cmakeFlags "-DKDE_INSTALL_LOCALSTATEDIR=/var"
    appendToVar cmakeFlags "-DKDE_INSTALL_SHAREDSTATEDIR=/com"  # ???
    appendToVar cmakeFlags "-DKDE_INSTALL_DATAROOTDIR=${!outputBin}/share"
    appendToVar cmakeFlags "-DKDE_INSTALL_DATADIR=${!outputBin}/share"
    appendToVar cmakeFlags "-DKDE_INSTALL_DOCBUNDLEDIR=${!outputBin}/share/doc/HTML"
    appendToVar cmakeFlags "-DKDE_INSTALL_KCFGDIR=${!outputBin}/share/config.kcfg"
    appendToVar cmakeFlags "-DKDE_INSTALL_KCONFUPDATEDIR=${!outputBin}/share/kconf_update"
    appendToVar cmakeFlags "-DKDE_INSTALL_KAPPTEMPLATESDIR=${!outputDev}/share/kdevappwizard/templates"
    appendToVar cmakeFlags "-DKDE_INSTALL_KFILETEMPLATESDIR=${!outputDev}/share/kdevfiletemplates/templates"
    appendToVar cmakeFlags "-DKDE_INSTALL_KXMLGUIDIR=${!outputBin}/share/kxmlgui5"  # Yes, this needs to be 5 and not 6. Don't ask.
    appendToVar cmakeFlags "-DKDE_INSTALL_KNOTIFYRCDIR=${!outputBin}/share/knotifications6"
    appendToVar cmakeFlags "-DKDE_INSTALL_ICONDIR=${!outputBin}/share/icons"
    appendToVar cmakeFlags "-DKDE_INSTALL_LOCALEDIR=${!outputLib}/share/locale"
    appendToVar cmakeFlags "-DKDE_INSTALL_SOUNDDIR=${!outputBin}/share/sounds"
    appendToVar cmakeFlags "-DKDE_INSTALL_TEMPLATEDIR=${!outputBin}/share/templates"
    appendToVar cmakeFlags "-DKDE_INSTALL_WALLPAPERDIR=${!outputBin}/share/wallpapers"
    appendToVar cmakeFlags "-DKDE_INSTALL_APPDIR=${!outputBin}/share/applications"
    appendToVar cmakeFlags "-DKDE_INSTALL_DESKTOPDIR=${!outputBin}/share/desktop-directories"
    appendToVar cmakeFlags "-DKDE_INSTALL_MIMEDIR=${!outputBin}/share/mime/packages"
    appendToVar cmakeFlags "-DKDE_INSTALL_METAINFODIR=${!outputBin}/share/metainfo"
    appendToVar cmakeFlags "-DKDE_INSTALL_QTQCHDIR=${!outputLib}/share/doc/qch"
    appendToVar cmakeFlags "-DKDE_INSTALL_QCHDIR=${!outputLib}/share/doc/qch"
    appendToVar cmakeFlags "-DKDE_INSTALL_MANDIR=${!outputBin}/share/man"
    appendToVar cmakeFlags "-DKDE_INSTALL_INFODIR=${!outputBin}/share/info"
    appendToVar cmakeFlags "-DKDE_INSTALL_DBUSDIR=${!outputBin}/share/dbus-1"
    appendToVar cmakeFlags "-DKDE_INSTALL_DBUSINTERFACEDIR=${!outputBin}/share/dbus-1/interfaces"
    appendToVar cmakeFlags "-DKDE_INSTALL_DBUSSERVICEDIR=${!outputBin}/share/dbus-1/services"
    appendToVar cmakeFlags "-DKDE_INSTALL_DBUSSYSTEMSERVICEDIR=${!outputBin}/share/dbus-1/system-services"
    appendToVar cmakeFlags "-DKDE_INSTALL_SYSCONFDIR=${!outputBin}/etc"
    appendToVar cmakeFlags "-DKDE_INSTALL_CONFDIR=${!outputBin}/etc/xdg"
    appendToVar cmakeFlags "-DKDE_INSTALL_AUTOSTARTDIR=${!outputBin}/etc/xdg/autostart"
    appendToVar cmakeFlags "-DKDE_INSTALL_LOGGINGCATEGORIESDIR=${!outputLib}/share/qlogging-categories6"
    appendToVar cmakeFlags "-DKDE_INSTALL_SYSTEMDUNITDIR=${!outputBin}/lib/systemd"
    appendToVar cmakeFlags "-DKDE_INSTALL_SYSTEMDUSERUNITDIR=${!outputBin}/share/systemd/user"
}
postHooks+=(ecmPostHook)

xdgDataSubdirs=("config.kcfg" "kconf_update" "knotifications6" "icons" "locale" "mime")

# ecmHostPathsSeen is an associative array of the paths that have already been
# seen by ecmHostPathHook.
declare -gA ecmHostPathsSeen

ecmHostPathIsNotSeen() {
    if [[ -n "${ecmHostPathsSeen["$1"]:-}" ]]; then
        # The path has been seen before.
        return 1
    else
        # The path has not been seen before.
        # Now it is seen, so record it.
        ecmHostPathsSeen["$1"]=1
        return 0
    fi
}

ecmHostPathHook() {
    ecmHostPathIsNotSeen "$1" || return 0

    local xdgConfigDir="$1/etc/xdg"
    if [ -d "$xdgConfigDir" ]
    then
        qtWrapperArgs+=(--prefix XDG_CONFIG_DIRS : "$xdgConfigDir")
    fi

    for xdgDataSubdir in "${xdgDataSubdirs[@]}"
    do
        if [ -d "$1/share/$xdgDataSubdir" ]
        then
            qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "$1/share")
            break
        fi
    done
}
addEnvHooks "$hostOffset" ecmHostPathHook
