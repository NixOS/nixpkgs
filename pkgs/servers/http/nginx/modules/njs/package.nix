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

  # njs module sources have to be writable during nginx build, so we copy them
  # to a temporary directory and change the module path in the configureFlags
  preConfigure = ''
    NJS_SOURCE_DIR=$(readlink -m "$TMPDIR/${finalAttrs.src}")
    mkdir -p "$(dirname "$NJS_SOURCE_DIR")"
    cp --recursive "${finalAttrs.src}" "$NJS_SOURCE_DIR"
    chmod -R u+rwX,go+rX "$NJS_SOURCE_DIR"
    export configureFlags="''${configureFlags/"${finalAttrs.src}"/"$NJS_SOURCE_DIR/nginx"} --with-ld-opt='-lz'"
    unset NJS_SOURCE_DIR
  '';

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
