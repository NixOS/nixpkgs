{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, dbus
, libX11
, libXrandr
}:

rustPlatform.buildRustPackage rec {
  pname = "system76-oled";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = version;
    sha256 = "sha256:0xy6fpr9k5wnq074flsxm1k27svvk4pvqyryhdsw1jpch46lzm1f";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ dbus libX11 libXrandr ];

  cargoSha256 = "sha256:13nhs17gzya1by5b301hl8q0pm9m9k1pnzmmgx1v1qam0zd7qj91";

  postInstall = ''
    install -D -m -0644 data/system76-oled.desktop $out/etc/xdg/autostart/system76-oled.desktop
  '';

  meta = with lib; {
    description = "Brightness control for System76 laptops with OLED displays";
    homepage = "https://github.com/pop-os/system76-oled";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zarthross ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "system76-oled";
  };
}
