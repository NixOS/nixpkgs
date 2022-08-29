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
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "ndilieto";
    repo = "uacme";
    rev = "v${version}";
    hash = "sha256-mbH5Z/ieV4fiLCLWag1aLPNA89sexd5upNF3KHTfhKM=";
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
    maintainers = with maintainers; [ malvo ];
  };
}
