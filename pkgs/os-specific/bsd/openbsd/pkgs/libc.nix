{
  lib,
  symlinkJoin,
  libcMinimal,
  librthread,
  libm,
  librpcsvc,
  libutil,
  version,
}:

symlinkJoin rec {
  name = "${pname}-${version}";
  pname = "libc-openbsd";
  inherit version;

  outputs = [
    "out"
    "dev"
    "man"
  ];

  paths =
    lib.concatMap
      (p: [
        (lib.getDev p)
        (lib.getLib p)
        (lib.getMan p)
      ])
      [
        libcMinimal
        libm
        librthread
        librpcsvc
        libutil
      ];

  postBuild = ''
    rm -r "$out/nix-support"
    mkdir -p "$man/share/man"
    mv "$out/share"/man* "$man/share/man"
    rmdir "$out/share"
    fixupPhase
  '';

  meta.platforms = lib.platforms.openbsd;
}
