{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "heatshrink";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "atomicobject";
    repo = "heatshrink";
    rev = "v${version}";
    hash = "sha256-Nm9/+JFMDXY1N90hmNFGh755V2sXSRQ4VBN9f8TcsGk=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  preInstall = ''
    mkdir -p $out/{bin,lib,include}
  '';

  doCheck = true;
  checkTarget = "test";

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    echo "Hello world" | \
      $out/bin/heatshrink -e - | \
      $out/bin/heatshrink -d - | \
      grep "Hello world"
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "A data compression/decompression library for embedded/real-time systems";
    homepage = "https://github.com/atomicobject/heatshrink";
    license = licenses.isc;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}
