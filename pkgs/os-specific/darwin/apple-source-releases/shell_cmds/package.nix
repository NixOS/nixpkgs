{
  lib,
  apple-sdk,
  bison,
  clang,
  fetchurl,
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

  oldTime_c = fetchurl {
    url = "https://github.com/apple-oss-distributions/shell_cmds/raw/shell_cmds-207.11.1/time/time.c";
    hash = "sha256-f7aRwIaKq6r37jpw0V+1Z/sZs5Rm7vy2S774HNBnwmY=";
  };
  oldTime_1 = fetchurl {
    url = "https://github.com/apple-oss-distributions/shell_cmds/raw/shell_cmds-207.11.1/time/time.1";
    hash = "sha256-ZIbNJPHLQVGq2tdUB6j0DEp9Hie+XUZkfuQm676Vpwc=";
  };
in
mkAppleDerivation {
  releaseName = "shell_cmds";

  outputs = [
    "out"
    "man"
  ];

  xcodeHash = "sha256-26N7AZV/G+ryc2Nu1v91rEdb1a6jDpnj6t5rzEG2YA4=";

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
    ''
    # Use an older version of `time.c` that’s compatible with the 10.12 SDK.
    + lib.optionalString (lib.versionOlder (lib.getVersion apple-sdk) "10.13") ''
      cp '${oldTime_c}' time/time.c
      cp '${oldTime_1}' time/time.1
    ''
    + lib.optionalString (lib.versionOlder (lib.getVersion apple-sdk) "11.0") ''
      # `rpmatch` was added in 11.0, so revert it to a simpler check on older SDKs.
      substituteInPlace find/misc.c \
        --replace-fail 'return (rpmatch(resp) == 1);' "return (resp[0] == 'y');"
      # Add missing header for older SDKs.
      sed -e '1i #include <sys/time.h>' -i w/proc_compare.c
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
