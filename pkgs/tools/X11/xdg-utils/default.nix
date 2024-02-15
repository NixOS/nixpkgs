{ lib, stdenv, fetchFromGitLab, fetchFromGitHub, fetchpatch, writeText
# docs deps
, libxslt, docbook_xml_dtd_412, docbook_xml_dtd_43, docbook_xsl, xmlto
# runtime deps
, resholve, bash, coreutils, dbus, file, gawk, glib, gnugrep, gnused, jq, lockfileProgs, nettools, procmail, procps, xdg-user-dirs
, perl, perlPackages
, mimiSupport ? false
, withXdgOpenUsePortalPatch ? true }:

let
  # A much better xdg-open
  mimisrc = fetchFromGitHub {
    owner = "march-linux";
    repo = "mimi";
    rev = "8e0070f17bcd3612ee83cb84e663e7c7fabcca3d";
    sha256 = "15gw2nyrqmdsdin8gzxihpn77grhk9l97jp7s7pr7sl4n9ya2rpj";
  };

  # Required by the common desktop detection code
  commonDeps = [ dbus coreutils gnugrep gnused ];
  # These are all faked because the current desktop is detected
  # based on their presence, so we want them to be missing by default.
  commonFakes = [
    "explorer.exe"
    "gnome-default-applications-properties"
    "kde-config"
    "xprop"
  ];

  # This is still required to work around the eval trickery some scripts do
  commonPrologue = "${writeText "xdg-utils-prologue" ''
    export PATH=$PATH:${coreutils}/bin
  ''}";

  solutions = [
    {
      scripts = [ "bin/xdg-desktop-icon" ];
      interpreter = "${bash}/bin/bash";
      inputs = commonDeps ++ [ xdg-user-dirs ];
      execer = [
        "cannot:${xdg-user-dirs}/bin/xdg-user-dir"
      ];
      # These are desktop-specific, so we don't want xdg-utils to be able to
      # call them when in a different setup.
      fake.external = commonFakes ++ [
        "gconftool-2"   # GNOME2
      ];
      keep."$KDE_SESSION_VERSION" = true;
      prologue = commonPrologue;
    }

    {
      scripts = [ "bin/xdg-desktop-menu" ];
      interpreter = "${bash}/bin/bash";
      inputs = commonDeps ++ [ gawk ];
      fake.external = commonFakes;
      keep."$KDE_SESSION_VERSION" = true;
      prologue = commonPrologue;
    }

    {
      scripts = [ "bin/xdg-email" ];
      interpreter = "${bash}/bin/bash";
      inputs = commonDeps ++ [ gawk glib.bin "${placeholder "out"}/bin" ];
      execer = [
        "cannot:${placeholder "out"}/bin/xdg-mime"
        "cannot:${placeholder "out"}/bin/xdg-open"
      ];
      # These are desktop-specific, so we don't want xdg-utils to be able to
      # call them when in a different setup.
      fake.external = commonFakes ++ [
        "exo-open"           # XFCE
        "gconftool-2"        # GNOME
        "gio"                # GNOME (new)
        "gnome-open"         # GNOME (very old)
        "gvfs-open"          # GNOME (old)
        "qtxdg-mat"          # LXQT
        "xdg-email-hook.sh"  # user-defined hook that may be available ambiently
      ];
      fix."/bin/echo" = true;
      keep = {
        "$command" = true;
        "$kreadconfig" = true;
        "$THUNDERBIRD" = true;
        "$utf8" = true;
      };
    }

    {
      scripts = [ "bin/xdg-icon-resource" ];
      interpreter = "${bash}/bin/bash";
      inputs = commonDeps;
      fake.external = commonFakes;
      keep."$KDE_SESSION_VERSION" = true;
      prologue = commonPrologue;
    }

    {
      scripts = [ "bin/xdg-mime" ];
      interpreter = "${bash}/bin/bash";
      inputs = commonDeps ++ [ file gawk ];
      # These are desktop-specific, so we don't want xdg-utils to be able to
      # call them when in a different setup.
      fake.external = commonFakes ++ [
        "gio"                # GNOME (new)
        "gnomevfs-info"      # GNOME (very old)
        "gvfs-info"          # GNOME (old)
        "kde4-config"        # Plasma 4
        "kfile"              # KDE 3
        "kmimetypefinder"    # Plasma (generic)
        "kmimetypefinder5"   # Plasma 5
        "ktraderclient"      # KDE 3
        "ktradertest"        # KDE 3
        "mimetype"           # alternative tool for file, pulls in perl, avoid
        "qtpaths"            # Plasma
        "qtxdg-mat"          # LXQT
      ];
      fix."/usr/bin/file" = true;
      keep = {
        "$KDE_SESSION_VERSION" = true;
        "$KTRADER" = true;
      };
      prologue = commonPrologue;
    }

    {
      scripts = [ "bin/xdg-open" ];
      interpreter = "${bash}/bin/bash";
      inputs = commonDeps ++ [ nettools glib.bin "${placeholder "out"}/bin" ];
      execer = [
        "cannot:${placeholder "out"}/bin/xdg-mime"
      ];
      # These are desktop-specific, so we don't want xdg-utils to be able to
      # call them when in a different setup.
      fake.external = commonFakes ++ [
        "cygstart"            # Cygwin
        "dde-open"            # Deepin
        "enlightenment_open"  # Enlightenment
        "exo-open"            # XFCE
        "gio"                 # GNOME (new)
        "gnome-open"          # GNOME (very old)
        "gvfs-open"           # GNOME (old)
        "kde-open"            # Plasma
        "kfmclient"           # KDE3
        "mate-open"           # MATE
        "mimeopen"            # alternative tool for file, pulls in perl, avoid
        "open"                # macOS
        "pcmanfm"             # LXDE
        "qtxdg-mat"           # LXQT
        "run-mailcap"         # generic
        "rundll32.exe"        # WSL
        "wslpath"             # WSL
      ];
      fix."$printf" = [ "printf" ];
      keep = {
        "env:$command" = true;
        "$browser" = true;
        "$KDE_SESSION_VERSION" = true;
      };
    }

    {
      scripts = [ "bin/xdg-screensaver" ];
      interpreter = "${bash}/bin/bash";
      inputs = commonDeps ++ [ lockfileProgs nettools perl procmail procps ];
      # These are desktop-specific, so we don't want xdg-utils to be able to
      # call them when in a different setup.
      fake.external = commonFakes ++ [
        "dcop"                      # KDE3
        "mate-screensaver-command"  # MATE
        "xautolock"                 # Xautolock
        "xscreensaver-command"      # Xscreensaver
        "xset"                      # generic-ish X
      ];
      fix."$lockfile_command" = [ "lockfile" ];
      keep = {
        "$MV" = true;
        "$XPROP" = true;
      };
      prologue = "${writeText "xdg-screensaver-prologue" ''
        export PERL5LIB=${with perlPackages; makePerlPath [ NetDBus XMLTwig XMLParser X11Protocol ]}
        export PATH=$PATH:${coreutils}/bin
      ''}";
    }

    {
      scripts = [ "bin/xdg-settings" ];
      interpreter = "${bash}/bin/bash";
      inputs = commonDeps ++ [ jq "${placeholder "out"}/bin" ];
      execer = [
        "cannot:${placeholder "out"}/bin/xdg-mime"
      ];
      # These are desktop-specific, so we don't want xdg-utils to be able to
      # call them when in a different setup.
      fake.external = commonFakes ++ [
        "gconftool-2"    # GNOME
        "kreadconfig"    # Plasma (generic)
        "kreadconfig5"   # Plasma 5
        "kreadconfig6"   # Plasma 6
        "ktradertest"    # KDE3
        "kwriteconfig"   # Plasma (generic)
        "kwriteconfig5"  # Plasma 5
        "kwriteconfig6"  # Plasma 6
        "qtxdg-mat"      # LXQT
      ];
      keep = {
        "$KDE_SESSION_VERSION" = true;
        # get_browser_$handler
        "$handler" = true;
      };
    }
  ];
in

stdenv.mkDerivation rec {
  pname = "xdg-utils";
  version = "1.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xdg";
    repo = "xdg-utils";
    rev = "v${version}";
    hash = "sha256-rjNIO4B9jHsBmPaugWTMqTGNpjiw0MTEmf9/ds2Mud4=";
  };

  patches = [
    # Backport typo fix
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/xdg/xdg-utils/-/commit/af2fe0d1dcbcd982d84ddf2bbd174afe90976ed9.patch";
      hash = "sha256-HhQk06wWkyWjSxjXet+sADKf1irswKxDA8WuOknZKRs=";
    })
    # Backport docs rendering fixes
    # See: https://gitlab.freedesktop.org/xdg/xdg-utils/-/merge_requests/106
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/xdg/xdg-utils/-/commit/403a720ad18920030418a7c3d1f2caba9ce3892d.patch";
      hash = "sha256-XxFUeyXENHCy+wplIJ5OzoU5oyA4v1bz/9qMXp1ZwsE=";
    })
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/xdg/xdg-utils/-/commit/a137f2ba87620402aca21b14fb1d79517782dd29.patch";
      hash = "sha256-XFUAWn4uOyzgLdvupBxsO7wm6VDSzYj1SGZEM+9ouec=";
    })
  ] ++ lib.optionals withXdgOpenUsePortalPatch [
    # Allow forcing the use of XDG portals using NIXOS_XDG_OPEN_USE_PORTAL environment variable.
    # Upstream PR: https://github.com/freedesktop/xdg-utils/pull/12
    ./allow-forcing-portal-use.patch
  ];

  # just needed when built from git
  nativeBuildInputs = [ libxslt docbook_xml_dtd_412 docbook_xml_dtd_43 docbook_xsl xmlto ];

  # explicitly provide a runtime shell so patchShebangs is consistent across build platforms
  buildInputs = [ bash ];

  postInstall = lib.optionalString mimiSupport ''
    cp ${mimisrc}/xdg-open $out/bin/xdg-open
  '';

  preFixup = lib.concatStringsSep "\n" (map (resholve.phraseSolution "xdg-utils-resholved") solutions);

  meta = with lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/xdg-utils/";
    description = "A set of command line tools that assist applications with a variety of desktop integration tasks";
    license = if mimiSupport then licenses.gpl2 else licenses.mit;
    maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
  };
}
