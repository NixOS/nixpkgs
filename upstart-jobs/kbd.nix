{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption;

  # think about where to put this chunk of code!
  # required by other pieces as well
  requiredTTYs = config.services.mingetty.ttys
    ++ config.boot.extraTTYs
    ++ [config.services.syslogd.tty];
  ttyNumbers = requiredTTYs;
  ttys = map (nr: "/dev/tty" + toString nr) ttyNumbers;
  defaultLocale = config.i18n.defaultLocale;
  consoleFont = config.i18n.consoleFont;
  consoleKeyMap = config.i18n.consoleKeyMap;

in

###### implementation

# most options are defined in i18n.nix

{

  inherit requiredTTYs; # pass them to upstart-job/default.nix

  # dummy option so that requiredTTYs can be passed, see above (FIXME)
  require = [
    {
      requiredTTYs = mkOption {
        default = [];
      };
    }
  ];

  services = {
    extraJobs = [{
      name = "kbd";

      extraPath = [
        pkgs.kbd
      ];
      
      job = "
        description \"Keyboard / console initialisation\"

        start on udev

        script

          export LANG=${defaultLocale}
          export PATH=${pkgs.gzip}/bin:$PATH # Needed by setfont

          set +e # continue in case of errors

          
          # Enable or disable UTF-8 mode.  This is based on
          # unicode_{start,stop}.
          echo 'Enabling or disabling Unicode mode...'

          charMap=$(${pkgs.glibc}/bin/locale charmap)

          if test \"$charMap\" = UTF-8; then

            for tty in ${toString ttys}; do

              # Tell the console output driver that the bytes arriving are
              # UTF-8 encoded multibyte sequences. 
              echo -n -e '\\033%G' > $tty

            done

            # Set the keyboard driver in UTF-8 mode.
            ${pkgs.kbd}/bin/kbd_mode -u

          else

            for tty in ${toString ttys}; do

              # Tell the console output driver that the bytes arriving are
              # UTF-8 encoded multibyte sequences. 
              echo -n -e '\\033%@' > $tty

            done

            # Set the keyboard driver in ASCII (or any 8-bit character
            # set) mode.
            ${pkgs.kbd}/bin/kbd_mode -a

          fi


          # Set the console font.
          for tty in ${toString ttys}; do
            ${pkgs.kbd}/bin/setfont -C $tty ${consoleFont}
          done


          # Set the keymap.
          ${pkgs.kbd}/bin/loadkeys '${consoleKeyMap}'


        end script
      ";
    
    }];
  };

}
