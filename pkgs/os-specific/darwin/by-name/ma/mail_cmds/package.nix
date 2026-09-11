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

  xcodeHash = "sha256-X9WKaCXm7gJI04iOJ3upmqTwZ6Lw+JjH0xSs+ng/9J0=";

  meta.description = "Traditional mail command for Darwin";
}
