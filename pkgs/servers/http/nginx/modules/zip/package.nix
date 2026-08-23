{
  fetchFromGitHub,
  fetchpatch,
  lib,
  mkNginxPlugin,
  stdenv,
}:

mkNginxPlugin (finalAttrs: {
  pname = "zip";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "evanmiller";
    repo = "mod_zip";
    tag = finalAttrs.version;
    hash = "sha256-Q5Z/0uVa8nVoQGH1Pfow9KHgnZdTGN8crbgWi/xCH/c=";
  };

  patches = [
    (fetchpatch {
      name = "fix-upstream-subrequest-crc-calculation.patch";
      url = "https://github.com/evanmiller/mod_zip/commit/8e65b82c82c7890f67a6107271c127e9881b6313.patch";
      hash = "sha256-rPmdWlTJID/GoS3Ud8S7DM93icA9zWTJ1a4DIVzH5Ug=";
    })
  ];

  meta = {
    description = "Streaming ZIP archiver for nginx";
    homepage = "https://github.com/evanmiller/mod_zip";
    license = lib.licenses.bsd3;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with lib.maintainers; [
      DutchGerman
      friedow
    ];
  };
})
