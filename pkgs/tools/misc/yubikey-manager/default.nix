{ pythonPackages, fetchurl, lib,
  yubikey-personalization, libu2f-host, libusb1 }:

pythonPackages.buildPythonPackage rec {
  name = "yubikey-manager-1.0.1";

  srcs = fetchurl {
    url = "https://developers.yubico.com/yubikey-manager/Releases/${name}.tar.gz";
    sha256 = "0i7w1f89hqlw7g800fjhbb6yvq9wjmj5d7w7p6v8bkyvk645v48z";
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

  # See https://github.com/NixOS/nixpkgs/issues/29169
  doCheck = false;

  meta = with lib; {
    homepage = https://developers.yubico.com/yubikey-manager;
    description = "Command line tool for configuring any YubiKey over all USB transports.";

    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ benley ];
  };
}
