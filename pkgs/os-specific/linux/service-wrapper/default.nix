{ stdenv, runCommand, substituteAll, coreutils }:

let
  name = "service-wrapper-${version}";
  version = "16.04.0"; # Ajar to Ubuntu Release
in
runCommand "${name}" {
  script = substituteAll {
    src = ./service-wrapper.sh;
    inherit (stdenv) shell;
    inherit coreutils;
  };

  meta = with stdenv.lib; {
    description = "A convenient wrapper for the systemctl commands, borrow from Ubuntu";
    license     = licenses.gpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ DerTim1 ];
  };
}
''
  mkdir -p $out/bin
  ln -s $out/bin $out/sbin
  cp $script $out/bin/service
  chmod a+x $out/bin/service
''
