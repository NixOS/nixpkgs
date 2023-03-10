{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "samplicator";
  version = "1.3.8rc1";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ];

  src = fetchFromGitHub {
    owner = "sleinen";
    repo = "samplicator";
    rev = version;
    sha256 = "0fv5vldmwd6qrdv2wkk946dk9rn9nrv3c84ldvvqqn1spxfzgirm";
  };

  meta = {
    description = "Send copies of (UDP) datagrams to multiple receivers";
    homepage = "https://github.com/sleinen/samplicator/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "samplicate";
    platforms = lib.platforms.unix;
  };
}
