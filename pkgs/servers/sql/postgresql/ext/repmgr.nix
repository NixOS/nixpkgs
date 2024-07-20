{ lib
, stdenv
, fetchFromGitHub
, postgresql
, openssl
, zlib
, readline
, flex
, curl
, json_c
, libxcrypt
}:

stdenv.mkDerivation rec {
  pname = "repmgr";
  version = "5.4.1";

  src = fetchFromGitHub {
    owner = "EnterpriseDB";
    repo = "repmgr";
    rev = "v${version}";
    sha256 = "sha256-OaEoP1BajVW9dt8On9Ppf8IXmAk47HHv8zKw3WlsLHw=";
  };

  nativeBuildInputs = [ flex ];

  buildInputs = postgresql.buildInputs ++ [ postgresql curl json_c ];

  installPhase = ''
    mkdir -p $out/{bin,lib,share/postgresql/extension}

    cp repmgr{,d} $out/bin
    cp *${postgresql.dlSuffix} $out/lib
    cp *.sql      $out/share/postgresql/extension
    cp *.control  $out/share/postgresql/extension
  '';

  meta = with lib; {
    homepage = "https://repmgr.org/";
    description = "Replication manager for PostgreSQL cluster";
    license = licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = with maintainers; [ zimbatm ];
  };
}

