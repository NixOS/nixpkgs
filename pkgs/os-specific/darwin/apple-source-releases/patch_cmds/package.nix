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

  xcodeHash = "sha256-FLCJY40l74ExO0WTaA8hb9guhOBXeui2GqWL/7QeJJk=";

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
