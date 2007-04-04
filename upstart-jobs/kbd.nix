{glibc, kbd, gzip, ttyNumbers, defaultLocale, consoleFont, consoleKeyMap}:

let

  ttys = map (nr: "/dev/tty" + toString nr) ttyNumbers;

in

{
  name = "kbd";

  extraPath = [
    kbd
  ];
  
  job = "
    description \"Keyboard / console initialisation\"

    start on udev

    script

      export LANG=${defaultLocale}
      export PATH=${gzip}/bin:$PATH # Needed by setfont

      set +e # continue in case of errors

      
      # Enable or disable UTF-8 mode.  This is based on
      # unicode_{start,stop}.
      echo 'Enabling or disabling Unicode mode...'

      charMap=$(${glibc}/bin/locale charmap)

      if test \"$charMap\" = UTF-8; then

        for tty in ${toString ttys}; do

          # Tell the console output driver that the bytes arriving are
          # UTF-8 encoded multibyte sequences. 
          echo -n -e '\\033%G' > $tty

        done

        # Set the keyboard driver in UTF-8 mode.
        ${kbd}/bin/kbd_mode -u

      else

        for tty in ${toString ttys}; do

          # Tell the console output driver that the bytes arriving are
          # UTF-8 encoded multibyte sequences. 
          echo -n -e '\\033%@' > $tty

        done

        # Set the keyboard driver in ASCII (or any 8-bit character
        # set) mode.
        ${kbd}/bin/kbd_mode -a

      fi


      # Set the console font.
      for tty in ${toString ttys}; do
        ${kbd}/bin/setfont -C $tty ${consoleFont}
      done


      # Set the keymap.
      ${kbd}/bin/loadkeys '${consoleKeyMap}'


    end script
  ";
  
}
