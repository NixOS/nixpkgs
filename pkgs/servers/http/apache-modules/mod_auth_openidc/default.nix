{
  lib,
  stdenv,
  autoreconfHook,
  pkg-config,
  apacheHttpd,
  apr,
  aprutil,
  cjose,
  curl,
  jansson,
  openssl,
  pcre2,
  zlib,
  fetchFromGitHub,
  nix-update-script,
  removeReferencesTo,
}:

stdenv.mkDerivation (finalAttrs: {

  pname = "mod_auth_openidc";
  version = "2.4.20.4";

  src = fetchFromGitHub {
    owner = "OpenIDC";
    repo = "mod_auth_openidc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9YBXozAcKj9XpBI67FQxIgeTpKVqsbtA7NFQW/9DdbY=";
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
    pcre2
  ];

  configureFlags = [
    "--with-apxs=${apacheHttpd.dev}/bin/apxs"
    "--without-hiredis"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 src/.libs/mod_auth_openidc.so $out/modules/mod_auth_openidc.so
    runHook postInstall
  '';

  disallowedReferences =
    map lib.getDev [
      apacheHttpd
      apr
      aprutil
      curl
      openssl
      jansson
      pcre2
      zlib
      stdenv.cc.libc
    ]
    ++ [ stdenv.cc.cc ];

  postFixup = ''
    for target in ${lib.escapeShellArgs (map toString finalAttrs.disallowedReferences)}; do
      ${lib.getExe removeReferencesTo} -t "$target" "$out/modules/mod_auth_openidc.so"
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/OpenIDC/mod_auth_openidc";
    description = "OpenID authentication and authorization module for Apache";
    changelog = "https://github.com/OpenIDC/mod_auth_openidc/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ mysaa ];
  };

})
