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
}:
postgresqlBuildExtension (finalAttrs: {
  pname = "documentdb";
  version = "0.102.0-ferretdb-2.0.0";

  src = fetchFromGitHub {
    owner = "ferretdb";
    repo = "documentdb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4lP4WFX1lWpk0YpDsxQydr9dkE5gd5FQ2cy9F4enxy8=";
  };
  patches = [
    (fetchpatch {
      url = "https://github.com/microsoft/documentdb/commit/99c07ce8991e739ca71a4c54824625d018431302.patch";
      hash = "sha256-qzmW+hVtFNGIGWMYXVoXG+M541vEs2rQh5d3Npp/E18=";
    })
  ];
  env = {
    NIX_CFLAGS_COMPILE = "-Wno-error";
    NIX_CFLAGS_LINK = "-lbid";
    BUILD_SOURCEBRANCH = finalAttrs.src.tag;
    BUILD_SOURCEVERSION = "NixOS";
  };

  postPatch = ''
    substituteInPlace Makefile.versions --replace-fail '$(GIT_INDEX_DIR)' ""
    patchShebangs scripts
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
