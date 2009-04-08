{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption mergeOneOption optionals filter concatMap concatMapStrings;
  cfg = config.services.xserver;
  xorg = cfg.package;

  # file provided by services.xserver.displayManager.session.script
  xsession = wm: dm: pkgs.writeText "xsession" ''

    source /etc/profile

    exec > $HOME/.Xerrors 2>&1


    ### Load X defaults.
    if test -e ~/.Xdefaults; then
      ${xorg.xrdb}/bin/xrdb -merge ~/.Xdefaults
    fi

    ${if cfg.startSSHAgent then ''
      ### Start the SSH agent.
      export SSH_ASKPASS=${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass
      eval $(${pkgs.openssh}/bin/ssh-agent)
    '' else ""}

    ### Allow user to override system-wide configuration
    if test -f ~/.xsession; then
        source ~/.xsession;
    fi

    # this script expect to have as first argument the following input
    # "desktop-manager + window-manager".
    arg="$1"

    # extract the window manager.
    windowManager="''${arg##* + }"
    : ''${windowManager:=${cfg.windowManager.default}}
    # extract the desktop manager.
    desktopManager="''${arg% + *}"
    : ''${desktopManager:=${cfg.desktopManager.default}}

    # used to restart the xserver.
    waitPID=0

    # handle window manager starts.
    case $windowManager in
      ${concatMapStrings (s: "
        (${s.name})
          ${s.start}
          ;;
      ") wm}
      (*) echo "$0: Window manager '$windowManager' not found.";;
    esac

    # handle desktop manager starts.
    case $desktopManager in
      ${concatMapStrings (s: "
        (${s.name})
          ${s.start}
          ;;
      ") dm}
      (*) echo "$0: Desktop manager '$desktopManager' not found.";;
    esac

    test "$waitPID" != 0 && wait "$waitPID"
    exit
  '';

in

{
  # list of display managers.
  require = [
    (import ./slim.nix)
  ];

  services = {
    xserver = {
      displayManager = {

        xauthBin = mkOption {
          default = "${xorg.xauth}/bin/xauth";
          description = "
            Path to the xauth binary used by display managers.
          ";
        };

        xserverBin = mkOption {
          default = "${xorg.xorgserver}/bin/X";
          description = "
            Path to the xserver binary used by display managers.
          ";
        };

        xserverArgs = mkOption {
          default = [];
          example = [
            "-ac"
            "-logverbose"
            "-nolisten tcp"
          ];
          description = "
            List of arguments which have to be pass to when
            the display manager start the xserver.
          ";
          apply = toString;
        };

        session = mkOption {
          default = [];
          example = [
            {
              manage = "desktop";
              name = "xterm";
              start = "
                ${pkgs.xterm}/bin/xterm -ls &
                waitPID=$!
              ";
            }
          ];
          description = ''
            List of session supported with the command used to start each
            session.  Each session script can set the
            <varname>waitPID</varname> shell variable to make this script
            waiting until the end of the user session.  Each script is used
            to define either a windows manager or a desktop manager.  These
            can be differentiated by setting the attribute
            <varname>manage</varname> either to <literal>"window"</literal>
            or <literal>"desktop"</literal>.

            The list of desktop manager and window manager should appear
            inside the display manager with the desktop manager name
            followed by the window manager name.
          '';
          apply = list: rec {
            wm = filter (s: s.manage == "window") list;
            dm = filter (s: s.manage == "desktop") list;
            names = concatMap (d: map (w: d.name + " + " + w.name) wm) dm;
            script = xsession wm dm;
          };
        };

        job = mkOption {
          default = {};
          example = {
            beforeScript = ''
              rm -f /var/log/slim.log
            '';
            env = ''
              env SLIM_CFGFILE=/etc/slim.conf
            '';
            execCmd = "${pkgs.slim}/bin/slim";
          };

          description = "
            List of arguments which have to be pass to when
            the display manager start the xserver.
          ";

          merge = mergeOneOption;
        };

      };
    };
  };
}
