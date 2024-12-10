{
  lib,
  fetchgit,
  buildGoModule,
  pigeon,
}:

buildGoModule rec {
  pname = "verifpal";
  version = "0.27.0";

  src = fetchgit {
    url = "https://source.symbolic.software/verifpal/verifpal.git";
    rev = "v${version}";
    hash = "sha256-rihY5p6nJ1PKjI+gn3NNXy+uzeBG2UNyRYy3UjScf2Q=";
  };

  vendorHash = "sha256-XOCRwh2nEIC+GjGwqd7nhGWQD7vBMLEZZ2FNxs0NX+E=";

  nativeBuildInputs = [ pigeon ];

  subPackages = [ "cmd/verifpal" ];

  # goversioninfo is for Windows only and can be skipped during go generate
  preBuild = ''
    substituteInPlace cmd/verifpal/main.go --replace "go:generate goversioninfo" "(disabled goversioninfo)"
    go generate verifpal.com/cmd/verifpal
  '';

  meta = {
    homepage = "https://verifpal.com/";
    description = "Cryptographic protocol analysis for students and engineers";
    mainProgram = "verifpal";
    maintainers = with lib.maintainers; [ zimbatm ];
    license = with lib.licenses; [ gpl3 ];
  };
}
