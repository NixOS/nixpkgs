{
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  mongoc,
  pcre2,
  intelrdfpmathlib,
  openssl,
  postgresqlBuildExtension,
  libkrb5,
  rum,
}:
postgresqlBuildExtension (finalAttrs: {
  pname = "documentdb";
  version = "0.103.0-ferretdb-2.2.0";

  src = fetchFromGitHub {
    owner = "ferretdb";
    repo = "documentdb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ewbSr7MBPTxOjGsA2DrBCqmQkbJ5ioobPcH4QKzgsnI=";
  };
  env = {
    NIX_CFLAGS_COMPILE = "-Wno-error";
    NIX_CFLAGS_LINK = "-lbid";
    BUILD_SOURCEBRANCH = finalAttrs.src.tag;
    BUILD_SOURCEVERSION = "NixOS";
  };

  postPatch = ''
    patchShebangs scripts
  '';

  postInstall = ''
    ln -s ${rum}/lib/rum.so $out/lib/rum.so
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    mongoc
    pcre2
    intelrdfpmathlib
    openssl
    libkrb5
  ];
})
