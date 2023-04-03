{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gotestwaf";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "wallarm";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-waYX7DMyLW0eSzpFRyiCJQdYLFGaAKSlvGYrdcRfCl4=";
  };

  vendorHash = null;

  # Some tests require networking as of v0.4.0
  doCheck = false;

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
