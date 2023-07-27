{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "murex";
  version = "4.4.9100";

  src = fetchFromGitHub {
    owner = "lmorg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3YXRjwDEJC4rZdvrgj8Hp8oD+4NN5LOUJmM/9bjwfQw=";
  };

  vendorHash = "sha256-eQfffqNxt6es/3/H59FC5mLn1IU3oMpY/quzgNOgOaU=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Bash-like shell and scripting environment with advanced features designed for safety and productivity";
    homepage = "https://murex.rocks";
    license = licenses.gpl2;
    maintainers = with maintainers; [ dit7ya ];
  };
}
