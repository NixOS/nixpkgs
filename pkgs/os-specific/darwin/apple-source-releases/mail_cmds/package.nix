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

  meta.description = "Traditional mail command for Darwin";
}
