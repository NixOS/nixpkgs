{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
  nixosTests,
  which,
  zlib,
}:

mkNginxPlugin (finalAttrs: {
  pname = "njs";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "nginx";
    repo = "njs";
    tag = finalAttrs.version;
    hash = "sha256-Ee55QKaeZ0mYGKUroKr/AYGoOCakEonU483qkhmZdzU=";
  };

  buildInputs = [
    which
    zlib
  ];

  passthru.tests = nixosTests.nginx-njs;
  meta = {
    description = "Subset of the JavaScript language that allows extending nginx functionality";
    homepage = "https://nginx.org/en/docs/njs/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jvanbruegge ];
  };
})
