{
  lib,
  buildTypstPackage,
  fetchFromGitHub,
}:

buildTypstPackage rec {
  pname = "oxifmt";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "PgBiel";
    repo = "typst-oxifmt";
    tag = "v${version}";
    hash = "sha256-OJpkUsoAOHHn7T2O+wICW4nLJ+epkAOfe5R1pMhv1MQ=";
  };

  meta = {
    homepage = "https://github.com/PgBiel/typst-oxifmt";
    description = "Convenient Rust-like string formatting in Typst";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ cherrypiejam ];
  };
}
