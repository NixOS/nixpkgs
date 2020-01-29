{ mkDerivation, fetchFromGitHub, qmake, pcsclite, pkgconfig, opensc }:

mkDerivation rec {
  pname = "chrome-token-signing";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "open-eid";
    repo = "chrome-token-signing";
    rev = "v${version}";
    sha256 = "1icbr5gyf7qqk1qjgcrf6921ws84j5h8zrpzw5mirq4582l5gsav";
  };

  buildInputs = [ qmake pcsclite pkgconfig ];
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
}
