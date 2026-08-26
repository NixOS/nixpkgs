{
  lib,
  stdenv,
  fetchurl,
  perl,
  bashNonInteractive,
  makeWrapper,
  version,
  sha256,
  patches ? [ ],
  extraBuildInputs ? [ ],
  ...
}:
stdenv.mkDerivation rec {
  pname = "patchutils";
  inherit version patches;

  src = fetchurl {
    url = "https://cyberelk.net/tim/data/patchutils/stable/${pname}-${version}.tar.xz";
    inherit sha256;
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    perl
    bashNonInteractive
  ]
  ++ extraBuildInputs;
  hardeningDisable = [ "format" ];

  preConfigure = ''
    export PERL=${perl.interpreter}
  '';

  postInstall = ''
    for bin in $out/bin/*; do
      if [[ ! -h "$bin" ]]; then
        wrapProgram "$bin" \
          --prefix PATH : "$out/bin"
      fi
    done
  '';

  doCheck = lib.versionAtLeast version "0.3.4";

  preCheck = ''
    patchShebangs tests
    chmod +x scripts/*
  ''
  + lib.optionalString (lib.versionOlder version "0.4.2") ''
    find tests -type f -name 'run-test' \
      -exec sed -i '{}' -e 's|/bin/echo|echo|g' \;
  '';

  strictDeps = true;

  meta = {
    description = "Tools to manipulate patch files";
    homepage = "http://cyberelk.net/tim/software/patchutils";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ artturin ];
  };
}
