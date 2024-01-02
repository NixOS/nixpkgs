{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "pass-file";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "dvogt23";
    repo = pname;
    rev = version;
    hash = "sha256-18KvmcfLwelyk9RV/IMaj6O/nkQEQz84eUEB/mRaKE4=";
  };

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "A pass extension that allows to add files to password-store.";
    homepage = "https://github.com/dvogt23/pass-file";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ taranarmo ];
    platforms = platforms.unix;
  };
}
