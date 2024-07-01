{ lib, stdenv, fetchFromGitea, autoreconfHook, check, pkg-config, file, protobufc
,withWolfSSL ? false, wolfssl
,withGnuTLS ? false, gnutls
,withJSON ? true, json_c
}:

stdenv.mkDerivation rec {
  pname = "riemann-c-client";
  version = "2.2.0";

  src = fetchFromGitea {
    domain = "git.madhouse-project.org";
    owner = "algernon";
    repo = "riemann-c-client";
    rev = "riemann-c-client-${version}";
    hash = "sha256-GAinZtEetRAl04CjxNCTCkGbvdhSZei7gon3KxEqiIY=";
  };

  outputs = [ "bin" "dev" "out" ];

  nativeBuildInputs = [ autoreconfHook check pkg-config ];
  buildInputs = [ file protobufc ]
    ++ lib.optional withWolfSSL wolfssl
    ++ lib.optional withGnuTLS gnutls
    ++ lib.optional withJSON json_c
  ;

  configureFlags = []
    ++ lib.optional withWolfSSL "--with-tls=wolfssl"
    ++ lib.optional withGnuTLS "--with-tls=gnutls"
  ;

  doCheck = true;
  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://git.madhouse-project.org/algernon/riemann-c-client";
    description = "C client library for the Riemann monitoring system";
    mainProgram = "riemann-client";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ pradeepchhetri ];
    platforms = platforms.linux;
  };
}
