{ stdenv }:

stdenv.mkDerivation rec {
  pname = "wooting-udev-rules";
  version = "20190601";

  # Source: https://wooting.helpscoutdocs.com/article/68-wootility-configuring-device-access-for-wootility-under-linux-udev-rules
  src = [ ./wooting.rules ];

  unpackPhase = ":";

  installPhase = ''
    install -Dpm644 $src $out/lib/udev/rules.d/70-wooting.rules
  '';

  meta = with stdenv.lib; {
    homepage = "https://wooting.helpscoutdocs.com/article/34-linux-udev-rules";
    description = "udev rules that give NixOS permission to communicate with Wooting keyboards";
    platforms = platforms.linux;
    license = "unknown";
    maintainers = with maintainers; [ davidtwco ];
  };
}
