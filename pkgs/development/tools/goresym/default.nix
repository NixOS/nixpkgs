{ stdenv, lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "goresym";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "mandiant";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-o2t542q6UGjWdhJkcAm34kGhPUGNsvZKf940T+vydoE=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-ElV5edbe1LQWbA1NKv52/rLZJeOLBahE4YBKg9OA7YY=";

  doCheck = true;

  meta = with lib; {
    description = "Go symbol recovery tool";
    homepage = "https://github.com/mandiant/GoReSym";
    license = licenses.mit;
    maintainers = with maintainers; [ thehedgeh0g ];
  };
}
