{
  fetchFromGitHub,
  lib,
  runCommand,
  rustPlatform,
  openssl,
  cargo,
  rustc,
  pkg-config,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: rec {
  pname = "acme";
  version = "0.4.1";
  src =
    let
      src = fetchFromGitHub {
        name = "acme";
        owner = "nginx";
        repo = "nginx-acme";
        tag = "v${finalAttrs.version}";
        hash = "sha256-+Nvjij/2g0AM97mhYYjkbfhhuxdFS61hx+JwtV+IwIY=";
      };
      combined =
        runCommand "vendored-repo"
          {
            nativeBuildInputs = [
              rustPlatform.cargoSetupHook
            ];
            cargoDeps = rustPlatform.importCargoLock {
              lockFile = "${src}/Cargo.lock";
            };
          }
          ''
            mkdir -p $out
            cp -r ${src}/* $out/

            runHook postUnpack
            cp -r cargo-vendor-dir $out/
            cp -r .cargo $out/
          '';
    in
    combined;

  preConfigure = ''
    export NGX_RUSTC_OPT="--config ${src}/.cargo/config.toml"
    export OPENSSL_NO_VENDOR=1
  '';

  buildInputs = [
    openssl
    cargo
    rustPlatform.bindgenHook
    rustc
    pkg-config
  ];

  meta = with lib; {
    description = "Implementation of the automatic certificate management (ACMEv2) protocol";
    homepage = "https://github.com/nginx/nginx-acme";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ nyanloutre ];
  };
})
