{ lib, stdenv, fetchFromGitHub, fetchpatch
, meson, ninja, pkg-config, unixtools
, dbus, libcap, polkit, systemd
}:

stdenv.mkDerivation rec {
  pname = "rtkit";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "heftig";
    repo = "rtkit";
    rev = "c295fa849f52b487be6433e69e08b46251950399";
    sha256 = "0yfsgi3pvg6dkizrww1jxpkvcbhzyw9110n1dypmzq0c5hlzjxcd";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/heftig/rtkit/commit/7d62095b94f8df3891c984a1535026d2658bb177.patch";
      sha256 = "17acv549zqcgh7sgprfagbf6drqsr0zdwvf1dsqda7wlqc2h9zn7";
    })

    (fetchpatch {
      url = "https://github.com/heftig/rtkit/commit/98f70edd8f534c371cb4308b9720739c5178918d.patch";
      sha256 = "18mnjjsdjfr184nkzi01xyphpdngi31ry4bmkv9ysjxf9wilv4nl";
    })
  ];

  nativeBuildInputs = [ meson ninja pkg-config unixtools.xxd ];
  buildInputs = [ dbus libcap polkit systemd ];

  mesonFlags = [
    "-Dinstalled_tests=false"

    "-Ddbus_systemservicedir=${placeholder "out"}/share/dbus-1/system-services"
    "-Ddbus_interfacedir=${placeholder "out"}/share/dbus-1/interfaces"
    "-Ddbus_rulesdir=${placeholder "out"}/etc/dbus-1/system.d"
    "-Dpolkit_actiondir=${placeholder "out"}/share/polkit-1/actions"
    "-Dsystemd_systemunitdir=${placeholder "out"}/etc/systemd/system"
  ];

  meta = with lib; {
    homepage = "https://github.com/heftig/rtkit";
    description = "A daemon that hands out real-time priority to processes";
    license = with licenses; [ gpl3 bsd0 ]; # lib is bsd license
    platforms = platforms.linux;
  };
}
