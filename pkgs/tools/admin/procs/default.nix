{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XR6HhMu5AN1vkR3YtDlogTN9/aEExFQtATyKUqWjyAM=";
  };

  cargoSha256 = "sha256-U1ewV/t66jrFRMdu5ddPWyg08C2IGFr6rudPFRIkPsg=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/procs --completion $shell
    done
    installShellCompletion procs.{bash,fish} --zsh _procs
  '';

  buildInputs = lib.optionals stdenv.isDarwin [ Security libiconv ];

  meta = with lib; {
    description = "A modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    changelog = "https://github.com/dalance/procs/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne SuperSandro2000 ];
    #   thread 'main' panicked at 'Unable to find libclang: "couldn't find any valid shared libraries matching: ['libclang.dylib'], set the `LIBCLANG_PATH` environment variable to a path where one of these files can be found (invalid: [])"', /private/tmp/nix-build-procs-0.12.3.drv-0/procs-0.12.3-vendor.tar.gz/bindgen/src/lib.rs:2144:31
    broken = stdenv.isDarwin;
  };
}
