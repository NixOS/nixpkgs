{ stdenv, lib, fetchFromGitHub, apacheHttpd }:

stdenv.mkDerivation rec {
  pname = "mod_cspnonce";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "wyattoday";
    repo = "mod_cspnonce";
    rev = version;
    hash = "sha256-uUWRKUjS2LvHgT5xrK+LZLQRHc6wMaxGca2OsVxVlRs=";
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
    description = "Apache2 module that makes it dead simple to add nonce values to the CSP";
    homepage = "https://github.com/wyattoday/mod_cspnonce";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dasj19 ];
  };
}
