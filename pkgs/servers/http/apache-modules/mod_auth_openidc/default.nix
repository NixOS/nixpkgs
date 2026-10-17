{
  lib,
  stdenv,
  autoreconfHook,
  pkg-config,
  apacheHttpd,
  aprutil,
  cjose,
  curl,
  jansson,
  pcre,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {

  pname = "mod_auth_openidc";
  version = "2.4.19.4";

  src = fetchFromGitHub {
    owner = "OpenIDC";
    repo = "mod_auth_openidc";
    rev = "v${version}";
    sha256 = "sha256-I/j8AYBd9pPH47/Rsry6DWSvJGFeFxYn7BpkK9dtnEE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    apacheHttpd
    aprutil
    cjose
    curl
    jansson
    pcre
  ];

  configureFlags = [
    "--with-apxs2=${apacheHttpd.dev}/bin/apxs"
  ];

  installPhase = ''
    mkdir -p $out/modules
    cp src/.libs/mod_auth_openidc.so $out/modules
  '';

  meta = {
    homepage = "https://github.com/OpenIDC/mod_auth_openidc";
    description = "OpenID authentication and authorization module for Apache";
    license = lib.licenses.asl20;
  };

}
