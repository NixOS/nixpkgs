{ lib
, fetchgit
, buildGoModule
, pigeon
}:

buildGoModule rec {
  pname = "verifpal";
  version = "0.27.2";

  src = fetchgit {
    url = "https://github.com/symbolicsoft/verifpal.git";
    rev = "v${version}";
    hash = "sha256-2R9yljkCTH/eKgssKV5XThQbzZ3wLEtScKsuG+YOeNk=";
  };

  vendorHash = "sha256-PfYnS94QfhkOcoUANMwfNSj4LyshIBT2VLFawauPxuE=";

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
  };
}
