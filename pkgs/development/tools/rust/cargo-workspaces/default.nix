{ fetchCrate
, lib
, rustPlatform
, pkg-config
, openssl
, zlib
, stdenv
, darwin
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
  version = "0.2.35";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-MHoVeutoMaHHl1uxv52NOuvXsssqDuyfHTuyTqg9y+U=";
  };

  cargoSha256 = "sha256-wUVNsUx7JS5icjxbz3CV1lNUvuuL+gTL2QzuE+030WU=";
  verifyCargoDeps = true;

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
