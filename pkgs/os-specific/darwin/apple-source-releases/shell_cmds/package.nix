{
  lib,
  apple-sdk,
  bison,
  buildPackages,
  clang,
  libbsd,
  libedit,
  libresolv,
  libsbuf,
  libutil,
  libxo,
  pkg-config,
  mkAppleDerivation,
}:

let
  # nohup requires vproc_priv.h from launchd
  launchd = apple-sdk.sourceRelease "launchd";
in
mkAppleDerivation {
  releaseName = "shell_cmds";

  outputs = [
    "out"
    "man"
  ];

  xcodeHash = "sha256-JXK5hIsNDjCh7n39IWvHK8O0A3ItBttDlnN1YmAn6y8=";

  postPatch =
    ''
      # Fix `mktemp` templates
      substituteInPlace sh/mkbuiltins \
        --replace-fail '-t ka' '-t ka.XXXXXX'
      substituteInPlace sh/mktokens \
        --replace-fail '-t ka' '-t ka.XXXXXX'

      # Update `/etc/locate.rc` paths to point to the store.
      for path in locate/locate/locate.updatedb.8 locate/locate/locate.rc locate/locate/updatedb.sh; do
        substituteInPlace $path --replace-fail '/etc/locate.rc' "$out/etc/locate.rc"
      done
    '';

  env.NIX_CFLAGS_COMPILE = "-I${launchd}/liblaunch";

  depsBuildBuild = [ clang ];

  nativeBuildInputs = [
    bison
    pkg-config
  ];

  buildInputs =
    [
      libedit
      libresolv
      libsbuf
      libutil
      libxo
    ]
    # xargs needs `strtonum`, which was added in 11.0.
    ++ lib.optionals (lib.versionOlder (lib.getVersion apple-sdk) "11.0") [ libbsd ];

  postInstall = ''
    # Patch the shebangs to use `sh` from shell_cmds.
    HOST_PATH="$out/bin" patchShebangs --host "$out/bin" "$out/libexec"
  '';

  meta = {
    description = "Darwin shell commands and the Almquist shell";
    license = [
      lib.licenses.bsd2
      lib.licenses.bsd3
    ];
  };
}
