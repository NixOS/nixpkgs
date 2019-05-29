{ python3Packages, fetchurl, lib,
  yubikey-personalization, libu2f-host, libusb1 }:

python3Packages.buildPythonPackage rec {
  pname = "yubikey-manager";
  version = "2.1.1";

  srcs = fetchurl {
    url = "https://developers.yubico.com/${pname}/Releases/${pname}-${version}.tar.gz";
    sha256 = "1jmczk6r6609kzbq4ixispkm4qpvw94wdyfps7q3r96x75si1p1s";
  };

  propagatedBuildInputs =
    with python3Packages; [
      click
      cryptography
      pyscard
      pyusb
      pyopenssl
      six
      fido2
    ] ++ [
      libu2f-host
      libusb1
      yubikey-personalization
    ];

  makeWrapperArgs = [
    "--prefix" "LD_LIBRARY_PATH" ":"
    (lib.makeLibraryPath [ libu2f-host libusb1 yubikey-personalization ])
  ];

  postInstall = ''
    mkdir -p $out/share/bash-completion/completions
    _YKMAN_COMPLETE=source $out/bin/ykman > $out/share/bash-completion/completions/ykman || :
  '';

  # See https://github.com/NixOS/nixpkgs/issues/29169
  doCheck = false;

  meta = with lib; {
    homepage = https://developers.yubico.com/yubikey-manager;
    description = "Command line tool for configuring any YubiKey over all USB transports.";

    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ benley mic92 ];
  };
}
