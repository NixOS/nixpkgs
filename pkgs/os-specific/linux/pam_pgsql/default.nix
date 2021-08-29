{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, postgresql, libgcrypt, pam }:

stdenv.mkDerivation rec {
  pname = "pam_pgsql";
  version = "0.7.3.2";

  src = fetchFromGitHub {
    owner = "pam-pgsql";
    repo = "pam-pgsql";
    rev = "release-${version}";
    sha256 = "1a68krq5m07zspdxwl1wmkr5j98zr9bdg4776kvplrsdcg97h4jk";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libgcrypt pam postgresql ];

  meta = with lib; {
    description = "Support to authenticate against PostgreSQL for PAM-enabled appliations";
    homepage = "https://github.com/pam-pgsql/pam-pgsql";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
