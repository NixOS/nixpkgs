{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, glib, udev }:

stdenv.mkDerivation rec {
  pname = "tuxedo-touchpad-switch";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "tuxedocomputers";
    repo = "tuxedo-touchpad-switch";
    rev = "v${version}";
    sha256 = "sha256-6it84mQkTGko5uiqdWRmgwfpQnNLK+14J7YCC2Ni98k=";
  };

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [ glib udev ];

  # default install target assumes FHS paths
  installPhase = ''
    runHook preInstall

    install -Dm555 tuxedo-touchpad-switch -t $out/bin
    install -Dm444 ../res/99-tuxedo-touchpad-switch.rules -t $out/lib/udev/rules.d
    install -Dm444 ../res/tuxedo-touchpad-switch-lockfile -t $out/etc
    install -Dm444 ../res/tuxedo-touchpad-switch.desktop -t $out/share/gdm/greeter/autostart
    install -Dm444 ../res/tuxedo-touchpad-switch.desktop -t $out/etc/xdg/autostart

    runHook postInstall
  '';

  meta = with lib; {
    description = "A Driver to enable and disable the touchpads on TongFang/Uniwill laptops";
    homepage = "https://github.com/tuxedocomputers/tuxedo-touchpad-switch";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ geri1701 ];
  };
}
