{
  lib,
  stdenv,
  fetchurl,
  perl,
  makeWrapper,
  version,
  sha256,
  patches ? [ ],
  extraBuildInputs ? [ ],
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "patchutils";
  inherit version patches;

  src = fetchurl {
    url = "https://cyberelk.net/tim/data/patchutils/stable/patchutils-${finalAttrs.version}.tar.xz";
    inherit sha256;
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perl ] ++ extraBuildInputs;
  hardeningDisable = [ "format" ];

  # tests fail when building in parallel
  enableParallelBuilding = false;

  preConfigure = ''
    export PERL=${perl.interpreter}
  '';

  postInstall = ''
    for bin in $out/bin/{splitdiff,rediff,editdiff,dehtmldiff}; do
      wrapProgram "$bin" \
        --prefix PATH : "$out/bin"
    done
  '';

  doCheck = lib.versionAtLeast finalAttrs.version "0.3.4";

  preCheck = ''
    patchShebangs tests
    chmod +x scripts/*
  ''
  + lib.optionalString (lib.versionOlder finalAttrs.version "0.4.2") ''
    find tests -type f -name 'run-test' \
      -exec sed -i '{}' -e 's|/bin/echo|echo|g' \;
  '';

  strictDeps = true;

  __structuredAttrs = true;

  meta = {
    description = "Tools to manipulate patch files";
    homepage = "http://cyberelk.net/tim/software/patchutils";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ artturin ];
  };
})
