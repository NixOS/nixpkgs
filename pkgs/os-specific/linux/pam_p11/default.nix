{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, openssl, libp11, pam, libintl }:

stdenv.mkDerivation rec {
  pname = "pam_p11";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "pam_p11";
    rev = "pam_p11-${version}";
    sha256 = "1caidy18rq5zk82d51x8vwidmkhwmanf3qm25x1yrdlbhxv6m7lk";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ pam openssl libp11 ]
    ++ lib.optionals stdenv.isDarwin [ libintl ];

  meta = with lib; {
    homepage = "https://github.com/OpenSC/pam_p11";
    description = "Authentication with PKCS#11 modules";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sb0 ];
  };
}
