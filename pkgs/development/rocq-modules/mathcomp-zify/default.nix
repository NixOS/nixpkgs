{
  lib,
  mkRocqDerivation,
  rocq-core,
  mathcomp-boot,
  mathcomp-fingroup,
  mathcomp-algebra,
  stdlib,
  version ? null,
}:

mkRocqDerivation {
  namePrefix = [
    "rocq"
    "mathcomp"
  ];
  pname = "zify";
  repo = "mczify";
  owner = "math-comp";
  inherit version;

  defaultVersion =
    let
      case = rocq: mc: out: {
        cases = [
          rocq
          mc
        ];
        inherit out;
      };
    in
    with lib.versions;
    lib.switch
      [ rocq-core.rocq-version mathcomp-algebra.version ]
      [
        (case (range "9.0" "9.3") (range "2.4.0" "2.6.0") "1.7.0+2.4+9.0")
        (case (range "8.18" "9.1") (range "2.3.0" "2.5.0") "1.6.0+2.3+8.18")
        (case (range "8.16" "9.1") (range "2.0.0" "2.5.0") "1.5.0+2.0+8.16")
        (case (range "8.13" "8.20") (range "1.12" "1.19.0") "1.3.0+1.12+8.13")
        (case (range "8.13" "8.16") (range "1.12" "1.17.0") "1.1.0+1.12+8.13")
      ]
      null;

  release."1.0.0+1.12+8.13".hash = "sha256:1j533vx6lacr89bj1bf15l1a0s7rvrx4l00wyjv99aczkfbz6h6k";
  release."1.1.0+1.12+8.13".hash = "sha256:1plf4v6q5j7wvmd5gsqlpiy0vwlw6hy5daq2x42gqny23w9mi2pr";
  release."1.3.0+1.12+8.13".hash = "sha256-ebfY8HatP4te44M6o84DSLpDCkMu4IroPCy+HqzOnTE=";
  release."1.5.0+2.0+8.16".hash = "sha256-boBYGvXdGFc6aPnjgSZYSoW4kmN5khtNrSV3DUv9DqM=";
  release."1.6.0+2.3+8.18".hash = "sha256-rI5ZWtgO0a2sxCVChTdASxWxhgYEbM4OhC0dnSMRzZ8=";
  release."1.7.0+2.4+9.0".hash = "sha256-2dEIx/c0zLagT9jW1aDE/87ztg51HrY1wP7ioQYpUTQ=";

  propagatedBuildInputs = [
    mathcomp-boot
    mathcomp-algebra
    mathcomp-fingroup
    stdlib
  ];

  useCoqifVersion = v: v != null && v != "dev" && lib.versions.isLe "1.6.0+2.3+8.18" v;

  meta = {
    description = "Micromega tactics for Mathematical Components";
    maintainers = with lib.maintainers; [ cohencyril ];
  };
}
