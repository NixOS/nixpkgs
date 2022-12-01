{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "authz0";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8WtvUeHP7fJ1/G+UB1QLCSSNx7XA+vREcwJxoMeQsgM=";
  };

  vendorSha256 = "sha256-EQhvHu/LXZtVQ+MzjB96K0MUM4THiRDe1FkAATfGhdw=";

  meta = with lib; {
    description = "Automated authorization test tool";
    homepage = "https://github.com/hahwul/authz0";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
