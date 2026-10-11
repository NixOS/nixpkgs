{
  fetchFromGitHub,
  makeSetupHook,
  mkNginxPlugin,
  nixosTests,
  pkgs,
  lib,

  libcoraza,
}:

let
  # coraza nginx connector deliberately uses dynamic linking. static linking
  # does not work; it results in a silent drop of all requests. so embed
  # libcoraza location in RPATH.
  corazaNginxRpathHook = makeSetupHook { name = "coraza-nginx-rpath-hook"; } (
    pkgs.writeText "coraza-nginx-rpath-hook.sh" ''
      appendToVar postFixup 'patchelf --add-rpath ${lib.makeLibraryPath [ libcoraza ]} "$out/bin/nginx"'
    ''
  );
in
mkNginxPlugin (finalAttrs: {
  pname = "coraza";
  version = "0.21.0";
  src = fetchFromGitHub {
    owner = "corazawaf";
    repo = "coraza-nginx";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QnaN7HaSuqrw2XIB/oSIzR9kpIzid1HDjgJvWd5Dd40=";
  };

  buildInputs = [
    libcoraza
    corazaNginxRpathHook
  ];

  passthru.tests = {
    basic = nixosTests.nginx-coraza;
  };

  meta = {
    description = "NGINX plugin for the Coraza web application firewall";
    homepage = "https://github.com/corazawaf/coraza-nginx";
    license = [ lib.licenses.asl20 ];
  };
})
