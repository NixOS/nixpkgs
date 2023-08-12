{ lib
, stdenv
, autoreconfHook
, fetchFromGitHub
, pkg-config
, talloc
}:

stdenv.mkDerivation rec {
  pname = "libasn1c";
  version = "0.9.35";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "libasn1c";
    rev = version;
    hash = "sha256-mi97sWo42U/02xv4QDyUTRh26cyxhcOV5npqCuWsUOc=";
  };

  postPatch = ''
    echo "${version}" > .tarball-version
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    talloc
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Runtime library of Lev Walkin's asn1c split out as separate library";
    homepage = "github.com/osmocom/libasn1c/";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ janik ];
  };
}
