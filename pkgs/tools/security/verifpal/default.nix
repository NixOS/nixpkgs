{ lib
, fetchgit
, buildGoModule
, pigeon
}:

buildGoModule rec {
  pname = "verifpal";
  version = "0.26.0";

  src = fetchgit {
    url = "https://source.symbolic.software/verifpal/verifpal.git";
    rev = "v${version}";
    sha256 = "1ag1fpgk4xa5041y6a0pchmh32j876bl0iqjb7lxxqg5nc76d3v1";
  };

  vendorSha256 = "XHeXonzRDHXayge5G3apvDarbOfTiV+UQ+IqSbrLkCk=";

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
