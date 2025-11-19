{
  lib,
  apple-sdk,
  mkAppleDerivation,
  pkg-config,
  shell_cmds,
  stdenvNoCC,
  zlib,
}:

let
  xnu = apple-sdk.sourceRelease "xnu";

  privateHeaders = stdenvNoCC.mkDerivation {
    name = "doc_cmds-deps-private-headers";

    buildCommand = ''
      install -D -m644 -t "$out/include/System/sys" \
        '${xnu}/bsd/sys/codesign.h'

      install -D -m644 -t "$out/include/kern" \
        '${xnu}/osfmk/kern/cs_blobs.h'
    '';
  };
in
mkAppleDerivation {
  releaseName = "doc_cmds";

  outputs = [
    "out"
    "man"
  ];

  xcodeHash = "sha256-Nt6yHx3K8OkrdSWuX9s+JJIkeA5S6HDBAtTtrEjbk4w=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ zlib ];

  env.NIX_CFLAGS_COMPILE = "-I${privateHeaders}/include";

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
