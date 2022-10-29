{ stdenv
, fetchurl
, lib
, dpkg
, makeWrapper
, autoPatchelfHook
, ica-securestore-pkcs11
, libsForQt5
, curl
, pcsclite
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ica-securestore";
  version = "6.3.3";

  src = fetchurl {
    url = "http://ca.ica.cz/pub/SecureStore/linux/ica-securestore_${finalAttrs.version}-1_amd64.deb";
    sha256 = "m/pP6J2OrPPnm0C4hsUZnA+FDYFO+c7LAjbddRAt6zE=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtgraphicaleffects
    libsForQt5.wrapQtAppsHook
    curl
    pcsclite
  ];

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb -x "$src" .

    runHook postUnpack
  '';

  postPatch = ''
    substituteInPlace etc/ICA/cz.ica.SecureStore.ini \
      --replace "/usr/lib/pkcs11/libICASecureStorePkcs11.so" "${ica-securestore-pkcs11}/lib/pkcs11/libICASecureStorePkcs11.so"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp -ar usr/share "$out/share"
    cp -ar etc "$out/etc"
    cp opt/ICASecureStore/bin/SecureStore "$out/bin/ICASecureStore"

    runHook postInstall
  '';

  meta = {
    description = "Manager for I.CA Starcos smart cards";
    homepage = "https://ica.cz";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ jtojnar ];
    platforms = [ "x86_64-linux" ];
  };
})
