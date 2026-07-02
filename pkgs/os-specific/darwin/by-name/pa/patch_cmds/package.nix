{
  lib,
  apple-sdk,
  libutil,
  mkAppleDerivation,
  pkg-config,
}:

mkAppleDerivation {
  releaseName = "patch_cmds";

  outputs = [
    "out"
    "man"
  ];

  xcodeHash = "sha256-Ox8Ii2sUuledUttZ64DaHC0iFlUybs3lNZ23IDeziPM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libutil ];

  meta = {
    description = "BSD patch commands for Darwin";
    license = [
      lib.licenses.apple-psl10
      lib.licenses.bsd2 # -freebsd
      lib.licenses.bsd3
      lib.licenses.bsdOriginal
    ];
  };
}
