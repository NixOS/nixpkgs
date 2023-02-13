{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "periods";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "xocolatl";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XAqjP8Cih+HzqlI8XjgCNzSVQSbaetLRvJReiwHdaIc=";
  };

  buildInputs = [ postgresql ];

  installPhase = ''
    install -D -t $out/lib *.so
    install -D -t $out/share/postgresql/extension *.sql
    install -D -t $out/share/postgresql/extension *.control
  '';

  meta = with lib; {
    description = "PostgreSQL extension implementing SQL standard functionality for PERIODs and SYSTEM VERSIONING";
    homepage = "https://github.com/xocolatl/periods";
    maintainers = with maintainers; [ ivan ];
    platforms = postgresql.meta.platforms;
    license = licenses.postgresql;
    broken = versionOlder postgresql.version "9.5";
  };
}
