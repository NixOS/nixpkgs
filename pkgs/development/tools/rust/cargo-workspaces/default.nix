{ fetchCrate
, lib
, rustPlatform
, pkg-config
, openssl
, zlib
, stdenv
, libssh2
, libgit2
, IOKit
, Security
, CoreFoundation
, AppKit
, System
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-workspaces";
  version = "0.2.43";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-xLwDCXJ/Ab4H1U4M9z3Xx7WWCr0Po2mvbL6jWtU/4K4=";
  };

  cargoHash = "sha256-jia2n+rKIDewDLPZPvJ+7jdF9uT/afwDhu6aEgpX9Kc=";

  # needed to get libssh2/libgit2 to link properly
  LIBGIT2_SYS_USE_PKG_CONFIG = true;
  LIBSSH2_SYS_USE_PKG_CONFIG = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl zlib libssh2 libgit2 ] ++ (
    lib.optionals stdenv.isDarwin ([ IOKit Security CoreFoundation AppKit ]
      ++ (lib.optionals stdenv.isAarch64 [ System ]))
  );

  meta = with lib; {
    description = "A tool for managing cargo workspaces and their crates, inspired by lerna";
    longDescription = ''
      A tool that optimizes the workflow around cargo workspaces with
      git and cargo by providing utilities to version, publish, execute
      commands and more.
    '';
    homepage = "https://github.com/pksunkara/cargo-workspaces";
    license = licenses.mit;
    maintainers = with maintainers; [ macalinao ];
  };
}
