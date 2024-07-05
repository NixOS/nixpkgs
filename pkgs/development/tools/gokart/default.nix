{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gokart";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-G1IjlJ/rmviFWy6RFfLtP+bhfYcDuB97leimU39YCoQ=";
  };

  vendorHash = "sha256-lgKYVgJlmUJ/msdIqG7EKAZuISie1lG7+VeCF/rcSlE=";

  # Would need files to scan which are not shipped by the project
  doCheck = false;

  meta = with lib; {
    description = "Static analysis tool for securing Go code";
    mainProgram = "gokart";
    homepage = "https://github.com/praetorian-inc/gokart";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
