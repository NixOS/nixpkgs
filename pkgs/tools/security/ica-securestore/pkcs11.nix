{ stdenv
, fetchurl
, lib
, dpkg
, autoPatchelfHook
, pcsclite
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ica-securestore-pkcs11";
  version = "5.1.8";

  src = fetchurl {
    url = "http://ca.ica.cz/pub/SecureStore/linux/ica-securestore-pkcs11_${finalAttrs.version}-1_amd64.deb";
    sha256 = "4kKsP7IkHnjUQVRHZSJ135OqJ4FIKfshPVFpWkIoyQY=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    pcsclite
    stdenv.cc.cc.lib
  ];

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb -x "$src" .

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/pkcs11"
    cp -ar usr/lib/pkcs11/libICASecureStorePkcs11.so "$out/lib/pkcs11"

    runHook postInstall
  '';

  meta = {
    description = "ICA SecureStore Pkcs11 module";
    homepage = "https://ica.cz";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ jtojnar ];
    platforms = [ "x86_64-linux" ];
  };
})
