{ lib
, stdenv
, fetchFromGitHub
, pkgconfig
, gnupg
, autoconf
, automake
, libtool
, pam
, libHX
, libxml2
, pcre
, perl
, openssl
, cryptsetup}:

stdenv.mkDerivation rec {
  pname = "pam_gnupg";
  version = "unstable-2019-10-25";

  src = fetchFromGitHub {
    owner = "cruegge";
    repo = "pam-gnupg";
    rev = "363a50820fc00d6af6f6c01b87bacab51b67cda7";
    sha256 = "1qf3vsb7na49cgsvr03an5s7bnhj88c2g391rsd53qaxji2ni9mg";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gnupg autoconf automake libtool pam libHX libxml2 pcre perl openssl cryptsetup ];

  preConfigure = ''
    ./autogen.sh --prefix=$out
    ./configure
    '';

  makeFlags = "DESTDIR=$(out)";

  meta = with lib; {
    description = "Unlock GnuPG keys on login";
    homepage = "https://github.com/cruegge/pam-gnupg";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dawidsowa ];
  };

}
