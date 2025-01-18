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

  meta = with lib; {
    description = "BSD patch commands for Darwin";
    license = [
      licenses.apple-psl10
      licenses.bsd2 # -freebsd
      licenses.bsd3
      licenses.bsdOriginal
    ];
  };
}
