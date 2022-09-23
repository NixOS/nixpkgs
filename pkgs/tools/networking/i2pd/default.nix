{ lib, stdenv, fetchFromGitHub
, installShellFiles
, boost, zlib, openssl
, upnpSupport ? true, miniupnpc ? null
, aesniSupport ? stdenv.hostPlatform.aesSupport
, avxSupport   ? stdenv.hostPlatform.avxSupport
}:

assert upnpSupport -> miniupnpc != null;

stdenv.mkDerivation rec {
  pname = "i2pd";
  version = "2.43.0";

  src = fetchFromGitHub {
    owner = "PurpleI2P";
    repo = pname;
    rev = version;
    sha256 = "sha256-JIO1Zm7me/SX0W7sVHOesERnqvC7jy0Fu1vfKFePFd0=";
  };

  buildInputs = with lib; [ boost zlib openssl ]
    ++ optional upnpSupport miniupnpc;

  nativeBuildInputs = [
    installShellFiles
  ];

  makeFlags =
    let ynf = a: b: a + "=" + (if b then "yes" else "no"); in
    [ (ynf "USE_AESNI" aesniSupport)
      (ynf "USE_AVX"   avxSupport)
      (ynf "USE_UPNP"  upnpSupport)
    ];

  enableParallelBuilding = true;

  installPhase = ''
    install -D i2pd $out/bin/i2pd
    install --mode=444 -D 'contrib/i2pd.service' "$out/etc/systemd/system/i2pd.service"
    installManPage 'debian/i2pd.1'
  '';

  meta = with lib; {
    homepage = "https://i2pd.website";
    description = "Minimal I2P router written in C++";
    license = licenses.bsd3;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.unix;
  };
}
