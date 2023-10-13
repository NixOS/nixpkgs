{ stdenv, lib, fetchFromGitHub, fetchpatch, libX11, IOKit }:

stdenv.mkDerivation rec {
  version = "1.2";
  pname = "spacenavd";

  src = fetchFromGitHub {
    owner = "FreeSpacenav";
    repo = "spacenavd";
    rev = "v${version}";
    sha256 = "sha256-UuM/HTgictvIvlUnHZ5Ha8XwBhDTbt7CG9c4jzKQl0s=";
  };

  buildInputs = [ libX11 ]
    ++ lib.optional stdenv.hostPlatform.isDarwin IOKit;

  configureFlags = [ "--disable-debug" ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  postInstall = ''
    install -Dm644 $src/contrib/systemd/spacenavd.service -t $out/lib/systemd/system
    substituteInPlace $out/lib/systemd/system/spacenavd.service \
      --replace-fail "/usr/local/bin/spacenavd" "$out/bin/spacenavd"
  '';

  meta = with lib; {
    homepage = "https://spacenav.sourceforge.net/";
    description = "Device driver and SDK for 3Dconnexion 3D input devices";
    longDescription = "A free, compatible alternative, to the proprietary 3Dconnexion device driver and SDK, for their 3D input devices (called 'space navigator', 'space pilot', 'space traveller', etc)";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sohalt ];
  };
}
