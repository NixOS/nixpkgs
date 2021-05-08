{ lib, fetchFromGitHub, rustPlatform, pkg-config, libusb1 }:

rustPlatform.buildRustPackage rec {
  pname = "ecpdap";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "adamgreig";
    repo = pname;
    rev = "v${version}";
    sha256 = "1va96hxm22a2lfy141x1sv5f5g8f6mp965an4jsff9qzi55kfv2g";
  };

  cargoSha256 = "1dk6x2f36c546qr415kzmqr2r4550iwdmj4chrb46p3hr64jddhd";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libusb1 ];

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    cp drivers/*.rules $out/etc/udev/rules.d
  '';

  meta = with lib; {
    description = "A tool to program ECP5 FPGAs";
    longDescription = ''
      ECPDAP allows you to program ECP5 FPGAs and attached SPI flash
      using CMSIS-DAP probes in JTAG mode.
    '';
    homepage = "https://github.com/adamgreig/ecpdap";
    license = licenses.asl20;
    maintainers = with maintainers; [ expipiplus1 ];
  };
}

