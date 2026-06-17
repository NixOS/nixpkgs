{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  wrapQtAppsHook,
  qmake,
  pcsclite,
  opensc,
}:

stdenv.mkDerivation rec {
  pname = "chrome-token-signing";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "open-eid";
    repo = "chrome-token-signing";
    rev = "v${version}";
    sha256 = "sha256-wKy/RVR7jx5AkMJgHXsuV+jlzyfH5nDRggcIUgh2ML4=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapQtAppsHook
  ];
  buildInputs = [
    qmake
    pcsclite
  ];
  dontUseQmakeConfigure = true;

  patchPhase = ''
    substituteInPlace host-linux/ee.ria.esteid.json --replace /usr $out
    # TODO: macos
    substituteInPlace host-shared/PKCS11Path.cpp \
      --replace opensc-pkcs11.so ${opensc}/lib/pkcs11/opensc-pkcs11.so
  '';

  installPhase = ''
    install -D -t $out/bin host-linux/chrome-token-signing
    # TODO: wire these up
    install -D -t $out/etc/chromium/native-messaging-hosts host-linux/ee.ria.esteid.json
    install -D -t $out/lib/mozilla/native-messaging-hosts host-linux/ff/ee.ria.esteid.json
  '';

  meta = {
    description = "Chrome and Firefox extension for signing with your eID on the web";
    mainProgram = "chrome-token-signing";
    homepage = "https://github.com/open-eid/chrome-token-signing/wiki";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.mmahut ];
    platforms = lib.platforms.linux;
  };
}
