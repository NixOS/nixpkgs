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
        cmakeFlags+=" -DKDE_INSTALL_BUNDLEDIR=${!outputBin}/Applications/KDE"
    fi

    cmakeFlags+=" -DKDE_INSTALL_EXECROOTDIR=${!outputBin}"
    cmakeFlags+=" -DKDE_INSTALL_BINDIR=${!outputBin}/bin"
    cmakeFlags+=" -DKDE_INSTALL_SBINDIR=${!outputBin}/sbin"
    cmakeFlags+=" -DKDE_INSTALL_LIBDIR=${!outputLib}/lib"
    cmakeFlags+=" -DKDE_INSTALL_LIBEXECDIR=${!outputLib}/libexec"
    cmakeFlags+=" -DKDE_INSTALL_CMAKEPACKAGEDIR=${!outputDev}/lib/cmake"

    if [ -n "${qtPluginPrefix-}" ]; then
        cmakeFlags+=" -DKDE_INSTALL_QTPLUGINDIR=${!outputBin}/$qtPluginPrefix"
        cmakeFlags+=" -DKDE_INSTALL_PLUGINDIR=${!outputBin}/$qtPluginPrefix"
    fi

    if [ -n "${qtQmlPrefix-}" ]; then
        cmakeFlags+=" -DKDE_INSTALL_QMLDIR=${!outputBin}/$qtQmlPrefix"
    fi

    cmakeFlags+=" -DKDE_INSTALL_INCLUDEDIR=${!outputInclude}/include"
    cmakeFlags+=" -DKDE_INSTALL_LOCALSTATEDIR=/var"
    cmakeFlags+=" -DKDE_INSTALL_SHAREDSTATEDIR=/com"  # ???
    cmakeFlags+=" -DKDE_INSTALL_DATAROOTDIR=${!outputBin}/share"
    cmakeFlags+=" -DKDE_INSTALL_DATADIR=${!outputBin}/share"
    cmakeFlags+=" -DKDE_INSTALL_DOCBUNDLEDIR=${!outputBin}/share/doc/HTML"
    cmakeFlags+=" -DKDE_INSTALL_KCFGDIR=${!outputBin}/share/config.kcfg"
    cmakeFlags+=" -DKDE_INSTALL_KCONFUPDATEDIR=${!outputBin}/share/kconf_update"
    cmakeFlags+=" -DKDE_INSTALL_KAPPTEMPLATESDIR=${!outputDev}/share/kdevappwizard/templates"
    cmakeFlags+=" -DKDE_INSTALL_KFILETEMPLATESDIR=${!outputDev}/share/kdevfiletemplates/templates"
    cmakeFlags+=" -DKDE_INSTALL_KXMLGUIDIR=${!outputBin}/share/kxmlgui5"  # Yes, this needs to be 5 and not 6. Don't ask.
    cmakeFlags+=" -DKDE_INSTALL_KNOTIFYRCDIR=${!outputBin}/share/knotifications6"
    cmakeFlags+=" -DKDE_INSTALL_ICONDIR=${!outputBin}/share/icons"
    cmakeFlags+=" -DKDE_INSTALL_LOCALEDIR=${!outputLib}/share/locale"
    cmakeFlags+=" -DKDE_INSTALL_SOUNDDIR=${!outputBin}/share/sounds"
    cmakeFlags+=" -DKDE_INSTALL_TEMPLATEDIR=${!outputBin}/share/templates"
    cmakeFlags+=" -DKDE_INSTALL_WALLPAPERDIR=${!outputBin}/share/wallpapers"
    cmakeFlags+=" -DKDE_INSTALL_APPDIR=${!outputBin}/share/applications"
    cmakeFlags+=" -DKDE_INSTALL_DESKTOPDIR=${!outputBin}/share/desktop-directories"
    cmakeFlags+=" -DKDE_INSTALL_MIMEDIR=${!outputBin}/share/mime/packages"
    cmakeFlags+=" -DKDE_INSTALL_METAINFODIR=${!outputBin}/share/appdata"
    cmakeFlags+=" -DKDE_INSTALL_QTQCHDIR=${!outputLib}/share/doc/qch"
    cmakeFlags+=" -DKDE_INSTALL_QCHDIR=${!outputLib}/share/doc/qch"
    cmakeFlags+=" -DKDE_INSTALL_MANDIR=${!outputBin}/share/man"
    cmakeFlags+=" -DKDE_INSTALL_INFODIR=${!outputBin}/share/info"
    cmakeFlags+=" -DKDE_INSTALL_DBUSDIR=${!outputBin}/share/dbus-1"
    cmakeFlags+=" -DKDE_INSTALL_DBUSINTERFACEDIR=${!outputBin}/share/dbus-1/interfaces"
    cmakeFlags+=" -DKDE_INSTALL_DBUSSERVICEDIR=${!outputBin}/share/dbus-1/services"
    cmakeFlags+=" -DKDE_INSTALL_DBUSSYSTEMSERVICEDIR=${!outputBin}/share/dbus-1/system-services"
    cmakeFlags+=" -DKDE_INSTALL_SYSCONFDIR=${!outputBin}/etc"
    cmakeFlags+=" -DKDE_INSTALL_CONFDIR=${!outputBin}/etc/xdg"
    cmakeFlags+=" -DKDE_INSTALL_AUTOSTARTDIR=${!outputBin}/etc/xdg/autostart"
    cmakeFlags+=" -DKDE_INSTALL_LOGGINGCATEGORIESDIR=${!outputLib}/share/qlogging-categories6"
    cmakeFlags+=" -DKDE_INSTALL_SYSTEMDUNITDIR=${!outputBin}/lib/systemd"
    cmakeFlags+=" -DKDE_INSTALL_SYSTEMDUSERUNITDIR=${!outputBin}/share/systemd/user"
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

    if [ -d "$1/share/dbus-1" ]
    then
        propagatedUserEnvPkgs+=" $1"
    fi
}
addEnvHooks "$hostOffset" ecmHostPathHook
