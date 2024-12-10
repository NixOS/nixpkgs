{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "nar-serve";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "nar-serve";
    rev = "v${version}";
    hash = "sha256-cSOYHYJJEGzFtkD4mjTmYBiM9CaWKt64xgV/JeNHpfM=";
  };

  vendorHash = "sha256-RpjLs4+9abbbysYAlPDUXBLe1cz4Lp+QmR1yv+LpYwQ=";

  doCheck = false;

  meta = with lib; {
    description = "Serve NAR file contents via HTTP";
    mainProgram = "nar-serve";
    homepage = "https://github.com/numtide/nar-serve";
    license = licenses.mit;
    maintainers = with maintainers; [
      rizary
      zimbatm
    ];
  };
}
