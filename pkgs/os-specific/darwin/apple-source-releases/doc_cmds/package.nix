{
  lib,
  mkAppleDerivation,
  pkg-config,
  shell_cmds,
  zlib,
}:

mkAppleDerivation {
  releaseName = "doc_cmds";

  outputs = [
    "out"
    "man"
  ];

  xcodeHash = "sha256-7/ADsfXTKqQhgratg2Twj7JgfFV0/U9rEvtsnX+NFPw=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ zlib ];

  postInstall = ''
    HOST_PATH='${lib.getBin shell_cmds}/bin' patchShebangs --host "$out/libexec"
  '';

  meta = {
    description = "makewhatis commands for Darwin";
    license = [
      lib.licenses.bsd2
      lib.licenses.bsd3
    ];
  };
}
