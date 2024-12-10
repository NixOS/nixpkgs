{
  buildGoModule,
  avahi,
  libusb1,
  pkg-config,
  lib,
  fetchFromGitHub,
  ronn,
}:
buildGoModule rec {
  pname = "ipp-usb";
  version = "0.9.25";

  src = fetchFromGitHub {
    owner = "openprinting";
    repo = "ipp-usb";
    rev = version;
    sha256 = "sha256-ryKQDzb31JA192lbCYkwJrXgwErViqIzP4mD2NmWdgA=";
  };

  postPatch = ''
    # rebuild with patched paths
    rm ipp-usb.8
    substituteInPlace Makefile --replace "install: all" "install: man"
    substituteInPlace systemd-udev/ipp-usb.service --replace "/sbin" "$out/bin"
    for i in Makefile paths.go ipp-usb.8.md; do
      substituteInPlace $i --replace "/usr" "$out"
      substituteInPlace $i --replace "/var/ipp-usb" "/var/lib/ipp-usb"
    done
  '';

  nativeBuildInputs = [
    pkg-config
    ronn
  ];
  buildInputs = [
    libusb1
    avahi
  ];

  vendorHash = "sha256-61vCER1yR70Pn+CrfTai1sgiQQLU6msb9jxushus5W4=";

  postInstall = ''
    # to accomodate the makefile
    cp $out/bin/ipp-usb .
    make install DESTDIR=$out
  '';

  meta = {
    description = "Daemon to use the IPP everywhere protocol with USB printers";
    mainProgram = "ipp-usb";
    homepage = "https://github.com/OpenPrinting/ipp-usb";
    maintainers = [ lib.maintainers.symphorien ];
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd2;
  };
}
