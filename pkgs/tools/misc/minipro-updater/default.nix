{ lib
, stdenv
, fetchFromGitHub
, qmake
, wrapQtAppsHook
, libusb1
}:

stdenv.mkDerivation rec {
  pname = "minipro-updater";
  version = "2022-03-04";

  src = fetchFromGitHub {
    owner = "radiomanV";
    repo = "TL866";
    rev = "7d9a3c601e602c082f5bd60319e19817d60d553e";
    sha256 = "sha256-1hg1dQhNQockLFougSdzd0bBrgD7wOEYLh8W/iHltIo=";
  };

  sourceRoot = "source/TL866_Updater/QT";

  nativeBuildInputs = [ qmake wrapQtAppsHook ];
  buildInputs = [ libusb1 ];

  installPhase = ''
    runHook preInstall

    install -Dm755 TL866_Updater -t $out/bin
    mkdir -p $out/lib/udev/rules.d
    cp ../../udev/60-minipro.rules $out/lib/udev/rules.d
    cp ../../udev/61-minipro-plugdev.rules $out/lib/udev/rules.d
    cp ../../udev/61-minipro-uaccess.rules $out/lib/udev/rules.d

    runHook postInstall
    '';

  meta = with lib; {
    homepage = "https://github.com/radiomanV/TL866";
    description = "An open source program for updating the MiniPRO TL866xx programmer";
    license = licenses.gpl2;
    maintainers = [ maintainers.luz ];
  };
}
