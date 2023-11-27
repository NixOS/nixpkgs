{ lib
, fetchFromGitHub
, rustPlatform
, dbus
, pkg-config
, openssl
, libevdev
}:

rustPlatform.buildRustPackage rec {
  pname = "tp-auto-kbbl";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "saibotd";
    repo = pname;
    rev = version;
    sha256 = "0db9h15zyz2sq5r1qmq41288i54rhdl30qy08snpsh6sx2q4443y";
  };

  cargoSha256 = "0m1gcvshbd9cfb0v6f86kbcfjxb4p9cxynmxgi4nxkhaszfyf56c";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus libevdev openssl ];

  meta = with lib; {
    description = "Auto toggle keyboard back-lighting on Thinkpads (and maybe other laptops) for Linux";
    homepage = "https://github.com/saibotd/tp-auto-kbbl";
    license = licenses.mit;
    maintainers = with maintainers; [ sebtm ];
    platforms = platforms.linux;
    mainProgram = "tp-auto-kbbl";
  };
}
