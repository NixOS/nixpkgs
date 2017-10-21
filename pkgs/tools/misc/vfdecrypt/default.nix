{ stdenv, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  name = "vfdecrypt-${version}";
  version = "unstable-2010-08-13";

  src = fetchFromGitHub {
    owner = "Tomer1510";
    repo = "VFDecrypt";
    rev = "4e2fa32816254907e82886b936afcae9859a876c";
    sha256 = "0b945805f7f60bf48556c2db45c9ab26485fb05acbc6160a563d529b20cb56a3";
  };

  buildInputs = [ openssl ];

  installPhase = ''
    mkdir -p $out/bin
    cp vfdecrypt $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A cross platform dmg decryption tool";
    license = licenses.mit;
    inherit (src.meta) homepage;
  };
}
