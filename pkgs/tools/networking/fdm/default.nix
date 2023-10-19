{ lib, stdenv, fetchFromGitHub, autoreconfHook, openssl, tdb, zlib, flex, bison }:

stdenv.mkDerivation rec {
  pname = "fdm";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "nicm";
    repo = pname;
    rev = version;
    hash = "sha256-Gqpz+N1ELU5jQpPJAG9s8J9UHWOJNhkT+s7+xuQazd0=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl tdb zlib flex bison ];

  postInstall = ''
    install fdm-sanitize $out/bin
    mkdir -p $out/share/doc/${pname}
    install -m644 MANUAL $out/share/doc/${pname}
    cp -R examples $out/share/doc/${pname}
  '';

  meta = with lib; {
    description = "Mail fetching and delivery tool - should do the job of getmail and procmail";
    maintainers = with maintainers; [ raskin ];
    platforms = with platforms; linux ++ darwin;
    homepage = "https://github.com/nicm/fdm";
    downloadPage = "https://github.com/nicm/fdm/releases";
    license = licenses.isc;
  };
}
