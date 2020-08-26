{ stdenv, mkDerivation, fetchFromGitHub, qmake, pcsclite, pkgconfig, opensc }:

mkDerivation rec {
  pname = "chrome-token-signing";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "open-eid";
    repo = "chrome-token-signing";
    rev = "v${version}";
    sha256 = "0fqgci4336fbnd944zx9w37d5ky7i27n6wvlp5zv3hj955ldbh7g";
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

  meta = with stdenv.lib; {
    description = "Chrome and Firefox extension for signing with your eID on the web";
    homepage = "https://github.com/open-eid/chrome-token-signing/wiki";
    license = licenses.lgpl21;
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.linux;
  };
}
