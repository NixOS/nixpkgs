{ pythonPackages, fetchurl, lib,
  yubikey-personalization, libu2f-host, libusb1 }:

pythonPackages.buildPythonPackage rec {
  name = "yubikey-manager-0.4.0";

  srcs = fetchurl {
    url = "https://developers.yubico.com/yubikey-manager/Releases/${name}.tar.gz";
    sha256 = "0dc0mqg8r6kjh0s2rmrggfxbx9imslajjrj80rffcvg64a2vgsgb";
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
    ] ++ [
      libu2f-host
      libusb1
      yubikey-personalization
    ];

  makeWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${libu2f-host}/lib:${libusb1}/lib:${yubikey-personalization}/lib"
  ];

  postInstall = ''
    mkdir -p $out/etc/bash_completion.d
    _YKMAN_COMPLETE=source $out/bin/ykman > $out/etc/bash_completion.d/ykman.sh ||true
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
