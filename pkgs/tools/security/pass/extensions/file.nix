{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pass-file";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "dvogt23";
    repo = "pass-file";
    tag = finalAttrs.version;
    hash = "sha256-18KvmcfLwelyk9RV/IMaj6O/nkQEQz84eUEB/mRaKE4=";
  };

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Pass extension that allows to add files to password-store";
    homepage = "https://github.com/dvogt23/pass-file";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ taranarmo ];
    platforms = lib.platforms.unix;
  };
})
