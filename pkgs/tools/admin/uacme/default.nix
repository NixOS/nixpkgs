{ lib
, stdenv
, fetchFromGitHub
, asciidoc
, autoconf-archive
, autoreconfHook
, pkg-config
, curl
, openssl
}:
stdenv.mkDerivation rec {
  pname = "uacme";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "ndilieto";
    repo = "uacme";
    rev = "v${version}";
    hash = "sha256-ywir6wLZCTgb7SurJ5S/1UIV1Lw4/Er1wwdgl630Eso=";
  };

  configureFlags = [ "--with-openssl" ];

  nativeBuildInputs = [
    asciidoc
    autoconf-archive
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    curl
    openssl
  ];

  meta = with lib; {
    description = "ACMEv2 client written in plain C with minimal dependencies";
    homepage = "https://github.com/ndilieto/uacme";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ malte-v ];
  };
}
