{ lib, stdenv, fetchFromGitHub
, boost, zlib, openssl
, upnpSupport ? true, miniupnpc ? null
, aesniSupport ? stdenv.hostPlatform.aesSupport
, avxSupport   ? stdenv.hostPlatform.avxSupport
}:

assert upnpSupport -> miniupnpc != null;

stdenv.mkDerivation rec {
  pname = "i2pd";
  version = "2.39.0";

  src = fetchFromGitHub {
    owner = "PurpleI2P";
    repo = pname;
    rev = version;
    sha256 = "sha256-j8kHuX5Ca90ODjmF94HpGvjSpocDSuSxfVmvbIYRAKo=";
  };

  buildInputs = with lib; [ boost zlib openssl ]
    ++ optional upnpSupport miniupnpc;

  makeFlags =
    let ynf = a: b: a + "=" + (if b then "yes" else "no"); in
    [ (ynf "USE_AESNI" aesniSupport)
      (ynf "USE_AVX"   avxSupport)
      (ynf "USE_UPNP"  upnpSupport)
    ];

  enableParallelBuilding = true;

  installPhase = ''
    install -D i2pd $out/bin/i2pd
  '';

  meta = with lib; {
    homepage = "https://i2pd.website";
    description = "Minimal I2P router written in C++";
    license = licenses.bsd3;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.unix;
  };
}
