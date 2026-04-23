{
  lib,
  mkAppleDerivation,
  pkg-config,
  shell_cmds,
  pkgs,
  stdenvNoCC,
  zlib,
}:

let
  f =
    pkgs: prev:
    if
      !pkgs.stdenv.hostPlatform.isDarwin
      || pkgs.stdenv.name == "bootstrap-stage0-stdenv-darwin"
      || !(pkgs.stdenv ? __bootPackages)
    then
      prev.darwin.sourceRelease
    else
      f pkgs.stdenv.__bootPackages pkgs;
  # TODO(reckenrode): Use `sourceRelease` after migration has been merged and all releases updated to the same version.
  bootstrapSourceRelease = f pkgs pkgs;
  xnu = bootstrapSourceRelease "xnu";

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
