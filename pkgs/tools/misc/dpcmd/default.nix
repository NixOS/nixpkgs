{ fetchFromGitHub
, lib
, libusb1
, pkg-config
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "dpcmd";
  version = "1.2";

  src = fetchFromGitHub {
    rev = "f5646a6fa966f2c2d0e3d7b2d234454fb9d4229a";
    owner = "DediProgSW";
    repo = "SF100Linux";
    sha256 = "0ljqqlzxsp74aci3h0ll59pifjkqskl4vp2898k79b6knb13xhil";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ];

  installPhase = ''
    runHook preInstall

    install -Dm755 ./dpcmd $out/bin/dpcmd
    install -Dm644 ChipInfoDb.dedicfg $out/share/DediProg/ChipInfoDb.dedicfg

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/DediProgSW/SF100Linux";
    description = "Linux software for SF100/SF600";
    license = licenses.gpl2;
    maintainers = with maintainers; [ felixsinger ];
    platforms = platforms.linux;
  };
}
