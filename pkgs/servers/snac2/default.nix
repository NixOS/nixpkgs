{ stdenv
, lib
, fetchFromGitea
, curl
, openssl
}:

stdenv.mkDerivation rec {
  pname = "snac2";
  version = "2.12";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "grunfink";
    repo = pname;
    rev = version;
    hash = "sha256-mSk4qWte3Lksb0fxUfVZGT34eWsS4VfUlGN5yt4/pgs=";
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
