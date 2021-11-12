{ lib, stdenv, fetchurl, pkg-config, openssl, check, pcsclite, PCSC
, withApplePCSC ? stdenv.isDarwin
}:

stdenv.mkDerivation rec {
  pname = "yubico-piv-tool";
  version = "2.0.0";

  src = fetchurl {
    url = "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-${version}.tar.gz";
    sha256 = "124lhlim05gw32ydjh1yawqbnx6wdllz1ir9j00j09wji3m11rfs";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl check ]
    ++ (if withApplePCSC then [ PCSC ] else [ pcsclite ]);

  configureFlags = [ "--with-backend=${if withApplePCSC then "macscard" else "pcsc"}" ];

  meta = with lib; {
    homepage = "https://developers.yubico.com/yubico-piv-tool/";
    description = ''
      Used for interacting with the Privilege and Identification Card (PIV)
      application on a YubiKey
    '';
    longDescription = ''
      The Yubico PIV tool is used for interacting with the Privilege and
      Identification Card (PIV) application on a YubiKey.
      With it you may generate keys on the device, importing keys and
      certificates, and create certificate requests, and other operations.
      A shared library and a command-line tool is included.
    '';
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
