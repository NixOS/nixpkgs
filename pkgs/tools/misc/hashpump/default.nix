{ stdenv, fetchFromGitHub, openssl, lib }:

stdenv.mkDerivation (finalAttrs: {
  pname = "hashpump";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "bwall";
    repo = "HashPump";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xL/1os17agwFtdq0snS3ZJzwJhk22ujxfWLH65IMMEM=";
  };

  makeFlags = [ "INSTALLLOCATION=${placeholder "out"}/bin/" ];

  buildInputs = [ openssl ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ./hashpump --test
    runHook postCheck
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = {
    description = "A tool to exploit the hash length extension attack in various hashing algorithms";
    homepage = "https://github.com/bwall/HashPump";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ t4ccer ];
    platforms = lib.platforms.linux;
  };
})
