{ lib
, stdenv
, mkMesonExecutable

, nix-store
, nix-expr
, nix-main
, nix-cmd

# Configuration Options

, version
}:

let
  inherit (lib) fileset;
in

mkMesonExecutable (finalAttrs: {
  pname = "nix";
  inherit version;

  workDir = ./.;
  fileset = fileset.unions ([
    ../../build-utils-meson
    ./build-utils-meson
    ../../.version
    ./.version
    ./meson.build
    ./meson.options

    # Symbolic links to other dirs
    ## exes
    ./build-remote
    ./doc
    ./nix-build
    ./nix-channel
    ./nix-collect-garbage
    ./nix-copy-closure
    ./nix-env
    ./nix-instantiate
    ./nix-store
    ## dirs
    ./scripts
    ../../scripts
    ./misc
    ../../misc

    # Doc nix files for --help
    ../../doc/manual/generate-manpage.nix
    ../../doc/manual/utils.nix
    ../../doc/manual/generate-settings.nix
    ../../doc/manual/generate-store-info.nix

    # Other files to be included as string literals
    ../nix-channel/unpack-channel.nix
    ../nix-env/buildenv.nix
    ./get-env.sh
    ./help-stores.md
    ../../doc/manual/source/store/types/index.md.in
    ./profiles.md
    ../../doc/manual/source/command-ref/files/profiles.md

    # Files
  ] ++ lib.concatMap
    (dir: [
      (fileset.fileFilter (file: file.hasExt "cc") dir)
      (fileset.fileFilter (file: file.hasExt "hh") dir)
      (fileset.fileFilter (file: file.hasExt "md") dir)
    ])
    [
      ./.
      ../build-remote
      ../nix-build
      ../nix-channel
      ../nix-collect-garbage
      ../nix-copy-closure
      ../nix-env
      ../nix-instantiate
      ../nix-store
    ]
  );

  buildInputs = [
    nix-store
    nix-expr
    nix-main
    nix-cmd
  ];

  preConfigure =
    # "Inline" .version so it's not a symlink, and includes the suffix.
    # Do the meson utils, without modification.
    ''
      chmod u+w ./.version
      echo ${version} > ../../../.version
    '';

  mesonFlags = [
  ];

  env = lib.optionalAttrs (stdenv.isLinux && !(stdenv.hostPlatform.isStatic && stdenv.system == "aarch64-linux")) {
    LDFLAGS = "-fuse-ld=gold";
  };

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
