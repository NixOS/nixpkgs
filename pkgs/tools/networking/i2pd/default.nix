{ lib, stdenv, fetchFromGitHub
, fetchpatch2
, installShellFiles
, boost, zlib, openssl
, upnpSupport ? true, miniupnpc
, aesniSupport ? stdenv.hostPlatform.aesSupport
, avxSupport   ? stdenv.hostPlatform.avxSupport
}:

stdenv.mkDerivation rec {
  pname = "i2pd";
  version = "2.52.0";

  src = fetchFromGitHub {
    owner = "PurpleI2P";
    repo = pname;
    rev = version;
    sha256 = "sha256-0n3cPF3KBuzNOagrn88HeTvFAu1sYTkijpiGr77X5GI=";
  };

  patches = [
    # Support miniupnp-2.2.8 (fixes #2071)
    (fetchpatch2 {
      url = "https://github.com/PurpleI2P/i2pd/commit/697d8314415b0dc0634fd1673abc589a080e0a31.patch?full_index=1";
      hash = "sha256-B9Ngw1yPrnF5pGLe1a5x0TlyInvQGcq1zQUKO/ELFzA=";
    })
  ];

  buildInputs = [ boost zlib openssl ]
    ++ lib.optional upnpSupport miniupnpc;

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
    mainProgram = "i2pd";
  };
}
