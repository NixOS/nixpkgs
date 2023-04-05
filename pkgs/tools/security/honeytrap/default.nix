{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule {
  pname = "honeytrap";
  version = "unstable-2020-12-10";

  src = fetchFromGitHub {
    owner = "honeytrap";
    repo = "honeytrap";
    rev = "affd7b21a5aa1b57f086e6871753cb98ce088d76";
    sha256 = "y1SWlBFgX3bFoSRGJ45DdC1DoIK5BfO9Vpi2h57wWtU=";
  };

  # Otherwise, will try to install a "scripts" binary; it's only used in
  # dockerize.sh, which we don't care about.
  subPackages = [ "." ];

  vendorSha256 = "W8w66weYzCpZ+hmFyK2F6wdFz6aAZ9UxMhccNy1X1R8=";

  meta = with lib; {
    description = "Advanced Honeypot framework";
    homepage = "https://github.com/honeytrap/honeytrap";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
