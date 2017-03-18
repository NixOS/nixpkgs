{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "samplicator-${version}";
  version = "1.3.8rc1";

  buildInputs = [ autoreconfHook ];

  src = fetchFromGitHub {
    owner = "sleinen";
    repo = "samplicator";
    rev = version;
    sha256 = "0fv5vldmwd6qrdv2wkk946dk9rn9nrv3c84ldvvqqn1spxfzgirm";
  };

  meta = {
    description = "Send copies of (UDP) datagrams to multiple receivers";
    homepage = https://github.com/sleinen/samplicator/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
