{
  lib,
  stdenv,
  fetchFromGitHub,
}:

## Usage
# In NixOS, simply add this package to services.udev.packages:
#   services.udev.packages = [ pkgs.android-udev-rules ];

stdenv.mkDerivation rec {
  pname = "android-udev-rules";
  version = "20240221";

  src = fetchFromGitHub {
    owner = "M0Rf30";
    repo = "android-udev-rules";
    rev = version;
    hash = "sha256-Zbztl8ZFLS2UME8LtbahINKk6OUG5jo0O07awMXCPWY=";
  };

  installPhase = ''
    runHook preInstall
    install -D 51-android.rules $out/lib/udev/rules.d/51-android.rules
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/M0Rf30/android-udev-rules";
    description = "Android udev rules list aimed to be the most comprehensive on the net";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ abbradar ];
  };
}
