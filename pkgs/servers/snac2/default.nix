{ stdenv
, lib
, fetchFromGitea
, curl
, openssl
}:

stdenv.mkDerivation rec {
  pname = "snac2";
  version = "2.15";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "grunfink";
    repo = pname;
    rev = version;
    hash = "sha256-aK98nolgf/pju6jPZell1qLZMxArDna4FMqf3THGV1I=";
  };

  buildInputs = [ curl openssl ];

  makeFlags = [ "PREFIX=$(out)" ];

  preInstall = "mkdir -p $out/bin";

  meta = with lib; {
    homepage = "https://codeberg.org/grunfink/snac2";
    description = "A simple, minimalistic ActivityPub instance (2.x, C)";
    license = licenses.mit;
    maintainers = with maintainers; [ misuzu ];
    platforms = platforms.linux;
  };
}
