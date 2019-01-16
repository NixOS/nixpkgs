{ pythonPackages, fetchurl, lib,
  yubikey-personalization, libu2f-host, libusb1 }:

pythonPackages.buildPythonPackage rec {
  name = "yubikey-manager-2.0.0";

  srcs = fetchurl {
    url = "https://developers.yubico.com/yubikey-manager/Releases/${name}.tar.gz";
    sha256 = "1x36pyg9g3by2pa11j6d73d79sdlb7qy98lwwn05f43fjm74qnz9";
  };

  propagatedBuildInputs =
    with pythonPackages;
    lib.optional (!pythonPackages.pythonAtLeast "3.4") enum34 ++ [
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

  checkInputs = with pythonPackages; lib.optionals (pythonPackages.pythonOlder "3.3") [ mock ];

  meta = with lib; {
    homepage = https://developers.yubico.com/yubikey-manager;
    description = "Command line tool for configuring any YubiKey over all USB transports.";

    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ benley ];
  };
}
