{
  lib,
  mkRocqDerivation,
  rocq-core,
  stdlib,
  version ? null,
}:

mkRocqDerivation {
  pname = "relation-algebra";
  owner = "damien-pous";

  inherit version;
  defaultVersion =
    lib.switch
      [ rocq-core.rocq-version ]
      [
        {
          cases = [ (lib.versions.isEq "9.0") ];
          out = "1.8.0";
        }
      ]
      null;

  releaseRev = v: "v${v}";

  release."1.8.0".sha256 = "sha256-RnY+a57KnStACteaT5dKQoCCH0qp7/W+4qoaApIilj0=";

  propagatedBuildInputs = [
    stdlib
  ];

  dontConfigure = true;

  mlPlugin = true;

  meta = {
    description = "Relation algebra library for Rocq";
    maintainers = with lib.maintainers; [ siraben ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
}
