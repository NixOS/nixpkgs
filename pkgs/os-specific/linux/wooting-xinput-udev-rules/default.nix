{ stdenv }:

stdenv.mkDerivation rec {
  pname = "wooting-xinput-udev-rules";
  version = "20210525";

  # Source: https://wooting.helpscoutdocs.com/article/83-guide-configuring-xinput-support-for-the-wootings-under-linux
  src = [ ./wooting-xinput.rules ];

  unpackPhase = ":";

  installPhase = ''
    install -Dpm644 $src $out/lib/udev/rules.d/71-wooting.rules
  '';

  meta = with stdenv.lib; {
    homepage = "https://wooting.helpscoutdocs.com/article/83-guide-configuring-xinput-support-for-the-wootings-under-linux";
    description = ''
      udev rules that give NixOS permission to communicate with Wooting keyboards in xinput mode
    '';
    platforms = platforms.linux;
    license = licenses.unfree;
    maintainers = with maintainers; [ davidtwco ];
  };
}
