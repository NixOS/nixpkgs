{
  lib,
  clang,
  mkAppleDerivation,
  buildPackages,
  shell_cmds,
}:

mkAppleDerivation {
  releaseName = "developer_cmds";

  outputs = [
    "out"
    "man"
  ];

  xcodeHash = "sha256-NurkF9AnPuaQ7Ev36PCknuTNV6z622yFi2bXZsow+xA=";

  postPatch = ''
    substituteInPlace rpcgen/rpc_main.c \
      --replace-fail '/usr/bin/cpp' '${lib.getBin buildPackages.clang}/bin/${buildPackages.clang.targetPrefix}cpp'
  '';

  postInstall = ''
    HOST_PATH='${lib.getBin shell_cmds}/bin' patchShebangs --host "$out/bin"
  '';

  meta = {
    description = "Developer commands for Darwin";
    license = [
      lib.licenses.bsd3
      lib.licenses.bsdOriginal
    ];
  };
}
