{
  lib,
  stdenv,
  fetchFromGitHub,
}:

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

<<<<<<< HEAD
  meta = {
    description = "Pass extension that allows to add files to password-store";
    homepage = "https://github.com/dvogt23/pass-file";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ taranarmo ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Pass extension that allows to add files to password-store";
    homepage = "https://github.com/dvogt23/pass-file";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ taranarmo ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
