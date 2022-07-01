{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gotestwaf";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "wallarm";
    repo = pname;
    rev = "v${version}";
    sha256 = "0c627bxx0mlxhc1fsd2k3x1lm5855pl215m88la662d70559z6k8";
  };

  vendorSha256 = null;

  postFixup = ''
    # Rename binary
    mv $out/bin/cmd $out/bin/${pname}
  '';

  meta = with lib; {
    description = "Tool for API and OWASP attack simulation";
    homepage = "https://github.com/wallarm/gotestwaf";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
