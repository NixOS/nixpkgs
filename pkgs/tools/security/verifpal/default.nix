{ lib
, fetchgit
, buildGoModule
, pigeon
}:

buildGoModule rec {
  pname = "verifpal";
  version = "0.13.7";

  src = fetchgit {
    url = "https://source.symbolic.software/verifpal/verifpal.git";
    rev = "v${version}";
    sha256 = "1ia3mxwcvcxghga2vvhf6mia59cm3jl7vh8laywh421bfj42sh9d";
  };

  vendorSha256 = "0cmj6h103igg5pcs9c9wrcmrsf0mwp9vbgzf5amsnj1206ryb1p2";

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
    maintainers = with lib.maintainers; [ zimbatm ];
    license = with lib.licenses; [ gpl3 ];
    platforms = [ "x86_64-linux" ];
  };
}
