{ buildGoModule, lib, fetchFromGitHub }:
buildGoModule rec {
  pname = "chamber";
  version = "2.8.2";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7L9RaE4LvHRR6MUimze5QpbnfasWJdY4arfS/Usy2q0=";
  };

  vendorSha256 = null;

  # set the version. see: chamber's Makefile
  buildFlagsArray = ''
    -ldflags=
    -X main.Version=v${version}
  '';

  meta = with lib; {
    description =
      "A tool for managing secrets by storing them in AWS SSM Parameter Store";
    homepage = "https://github.com/segmentio/chamber";
    license = licenses.mit;
    maintainers = with maintainers; [ kalekseev ];
  };
}
