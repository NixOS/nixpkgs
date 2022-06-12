{ stdenv, lib, fetchFromGitHub, apacheHttpd }:

stdenv.mkDerivation rec {
  pname = "mod_cspnonce";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "wyattoday";
    repo = "mod_cspnonce";
    rev = version;
    sha256 = "0kqvxf1dn8r0ywrfiwsxryjrxii2sq11wisbjnm7770sjwckwqh5";
  };

  buildInputs = [ apacheHttpd ];

  buildPhase = ''
    apxs -ca mod_cspnonce.c
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/modules
    cp .libs/mod_cspnonce.so $out/modules
    runHook postInstall
  '';

  meta = with lib; {
    description = "An Apache2 module that makes it dead simple to add nonce values to the CSP";
    homepage = "https://github.com/wyattoday/mod_cspnonce";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dasj19 ];
  };
}
