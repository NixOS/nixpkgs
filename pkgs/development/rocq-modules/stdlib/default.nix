{
  rocq-core,
  mkRocqDerivation,
  lib,
  version ? null,
}:
mkRocqDerivation {

  pname = "stdlib";
  repo = "stdlib";
  owner = "coq";
  opam-name = "rocq-stdlib";

  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch rocq-core.version [
      { case = isEq "9.0"; out = "9.0+rc1"; }
      { case = isLt "8.21"; out = "8.20"; }
    ] null;
  releaseRev = v: "V${v}";

  release."9.0+rc1".sha256 = "sha256-raHwniQdpAX1HGlMofM8zVeXcmlUs+VJZZg5VF43k/M=";
  release."8.20".sha256 = "sha256-AcoS4edUYCfJME1wx8UbuSQRF3jmxhArcZyPIoXcfu0=";

  useDune = true;

  configurePhase = ''
    patchShebangs dev/with-rocq-wrap.sh
  '';

  buildPhase = ''
    dev/with-rocq-wrap.sh dune build -p rocq-stdlib @install ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
  '';

  installPhase = ''
    dev/with-rocq-wrap.sh dune install --root . rocq-stdlib --prefix=$out --libdir $OCAMLFIND_DESTDIR
    mkdir $out/lib/coq/
    mv $OCAMLFIND_DESTDIR/coq $out/lib/coq/${rocq-core.rocq-version}
  '';

  meta = {
    description = "The Rocq Proof Assistant -- Standard Library";
    license = lib.licenses.lgpl21Only;
  };

}
