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
stdenv.mkDerivation rec {
  pname = "patchutils";
  inherit version patches;

  src = fetchurl {
    url = "http://cyberelk.net/tim/data/patchutils/stable/${pname}-${version}.tar.xz";
    inherit sha256;
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perl ] ++ extraBuildInputs;
  hardeningDisable = [ "format" ];

  # tests fail when building in parallel
  enableParallelBuilding = false;

  postInstall = ''
    for bin in $out/bin/{splitdiff,rediff,editdiff,dehtmldiff}; do
      wrapProgram "$bin" \
        --prefix PATH : "$out/bin"
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

  meta = with lib; {
    description = "Tools to manipulate patch files";
    homepage = "http://cyberelk.net/tim/software/patchutils";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ artturin ];
  };
}
