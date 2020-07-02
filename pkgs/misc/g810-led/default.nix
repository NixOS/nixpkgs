{ stdenv, fetchFromGitHub, hidapi
, profile ? "/etc/g810-led/profile"
}:

stdenv.mkDerivation rec {
  pname = "g810-led";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "MatMoul";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ymkp7i7nc1ig2r19wz0pcxfnpawkjkgq7vrz6801xz428cqwmhl";
  };

  buildInputs = [ hidapi ];

  installPhase = ''
    runHook preInstall
    install -D bin/g810-led $out/bin/g810-led
    ln -s \./g810-led $out/bin/g213-led
    ln -s \./g810-led $out/bin/g410-led
    ln -s \./g810-led $out/bin/g413-led
    ln -s \./g810-led $out/bin/g512-led
    ln -s \./g810-led $out/bin/g513-led
    ln -s \./g810-led $out/bin/g610-led
    ln -s \./g810-led $out/bin/g815-led
    ln -s \./g810-led $out/bin/g910-led
    ln -s \./g810-led $out/bin/gpro-led

    substituteInPlace udev/g810-led.rules \
      --replace "/usr" $out \
      --replace "/etc/g810-led/profile" "${profile}"
    install -D udev/g810-led.rules $out/etc/udev/rules.d/90-g810-led.rules
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Linux LED controller for Logitech G213, G410, G413, G512, G513, G610, G810, G815, G910 and GPRO Keyboards";
    inherit (src.meta) homepage;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ samuelgrf ];
  };
}
