{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, postgresql, libgcrypt, pam }:

stdenv.mkDerivation rec {
  version = "0.7.3.2";
  name = "pam_pgsql-${version}";

  src = fetchFromGitHub {
    owner = "pam-pgsql";
    repo = "pam-pgsql";
    rev = "release-${version}";
    sha256 = "1a68krq5m07zspdxwl1wmkr5j98zr9bdg4776kvplrsdcg97h4jk";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libgcrypt pam postgresql ];

  meta = with stdenv.lib; {
    description = "Support to authenticate against PostgreSQL for PAM-enabled appliations";
    homepage = "https://github.com/pam-pgsql/pam-pgsql";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
