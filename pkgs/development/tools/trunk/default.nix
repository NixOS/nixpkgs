{ lib,
stdenv,
rustPlatform,
fetchFromGitHub,
pkg-config,
openssl,
jq,
moreutils,
CoreServices,
SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "trunk";
  version = "0.18.3";

  src = fetchFromGitHub {
    owner = "thedodd";
    repo = "trunk";
    rev = "v${version}";
    hash = "sha256-R7i2tY8wd7Jhyx+zs+OqkZ+K+d/triBRqaAsATtCM+o=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = if stdenv.isDarwin
    then [ CoreServices SystemConfiguration ]
    else [ openssl ];
  # requires network
  checkFlags = [ "--skip=tools::tests::download_and_install_binaries" ];

  cargoHash = "sha256-70fzBqF/6bDStvhpc7IV4ekVEinBFqiCScK4X0HTkgY=";

  # the dependency css-minify contains both README.md and Readme.md,
  # which causes a hash mismatch on systems with a case-insensitive filesystem
  # this removes the readme files and updates cargo's checksum file accordingly
  depsExtraArgs = {
    nativeBuildInputs = [
      jq
      moreutils
    ];

    postBuild = ''
      pushd $name/css-minify

      rm -f README.md Readme.md
      jq 'del(.files."README.md") | del(.files."Readme.md")' \
        .cargo-checksum.json -c \
        | sponge .cargo-checksum.json

      popd
    '';
  };

  meta = with lib; {
    homepage = "https://github.com/thedodd/trunk";
    description = "Build, bundle & ship your Rust WASM application to the web";
    maintainers = with maintainers; [ freezeboy ];
    license = with licenses; [ asl20 ];
  };
}
