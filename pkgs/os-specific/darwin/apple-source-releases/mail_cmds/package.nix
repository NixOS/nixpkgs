{
  lib,
  apple-sdk,
  file_cmds,
  mkAppleDerivation,
  pkg-config,
}:

mkAppleDerivation {
  releaseName = "mail_cmds";

  outputs = [
    "out"
    "man"
  ];

  xcodeHash = "sha256-6rBflDgQkqWDc8XPLgKIO703bMamg2QlhUnP71hBX3I=";

  patches = [
    # Add implementations of missing functions for older SDKs
    ./patches/0003-Add-implementations-of-missing-APIs-for-older-SDKs.patch
  ];

  postPatch = ''
    cp '${file_cmds.src}/gzip/futimens.c' compat/futimens.c
  '';

  meta.description = "Traditional mail command for Darwin";
}
