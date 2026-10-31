{
  fetchFromGitHub,
  lib,
  stdenv,

  apacheHttpd,
  apr,
  aprutil,
  autoPatchelfHook,
  openldap,
  openssl,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mod-authnz-external";
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "phokz";
    repo = "mod-auth-external";
    tag = "mod_authnz_external-${finalAttrs.version}";
    hash = "sha256-6khXrkZMR4a94W9/HGF3XGM3JyhGiFp6Actj6UqO0Ak=";
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
    openldap
    openssl
  ];

  installPhase = ''
    mkdir -p $out/modules
    cp ./.libs/* $out/modules
  '';

  meta = {
    description = "External Authentication Module for Apache HTTP Server";
    homepage = "https://github.com/phokz/mod-auth-external";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
    platforms = lib.platforms.linux;
  };
})
