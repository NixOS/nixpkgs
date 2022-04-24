{ lib
, fetchgit
, buildGoModule
, pigeon
}:

buildGoModule rec {
  pname = "verifpal";
  version = "0.26.1";

  src = fetchgit {
    url = "https://source.symbolic.software/verifpal/verifpal.git";
    rev = "v${version}";
    sha256 = "sha256-y07RXv2QSyUJpGuFsLJ2sGNo4YzhoCYQr3PkUj4eIOY=";
  };

  vendorSha256 = "sha256-gUpgnd/xiLqRNl1bPzVp+0GM/J5GEx0VhUfo6JsX8N8=";

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
