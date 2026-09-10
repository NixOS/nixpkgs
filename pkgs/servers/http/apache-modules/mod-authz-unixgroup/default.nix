{
  fetchFromGitHub,
  lib,
  stdenv,

  apacheHttpd,
  apr,
  aprutil,
  autoPatchelfHook,
  libbsd,
  openldap,
  openssl,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mod-authz-unixgroup";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "phokz";
    repo = "mod-auth-external";
    tag = "mod_authz_unixgroup-${finalAttrs.version}";
    hash = "sha256-hX7ovar83rnNd4UoEzlBwvEyD7jB8oj1TPVlMWurmbo=";
  };

  configureFlags = [ "--with-apxs2=${lib.getDev apacheHttpd}/bin/apxs" ];

  nativeBuildInputs = [
    autoPatchelfHook
    pkg-config
  ];
  buildInputs = [
    apacheHttpd
    apr
    aprutil
    libbsd
    openldap
    openssl
  ];

  installPhase = ''
    mkdir -p $out/modules
    cp ./.libs/* $out/modules
  '';

  meta = {
    description = "Unix group access control modules for Apache";
    homepage = "https://github.com/phokz/mod-auth-external";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
    platforms = lib.platforms.linux;
  };
})
