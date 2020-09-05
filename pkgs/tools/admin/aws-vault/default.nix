{ buildGoModule, lib, fetchFromGitHub }:
buildGoModule rec {
  pname = "aws-vault";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "99designs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ssm58ksk5jb28w1ipa57spzf6wixjy1m7flw61ls8k86cy7qb7c";
  };

  vendorSha256 = "0lxm7nkzf9j9id7m46gqn26prb1jfl34gy1fycr0578absdvsrjd";

  doCheck = false;

  subPackages = [ "." ];

  # set the version. see: aws-vault's Makefile
  buildFlagsArray = ''
    -ldflags=
    -X main.Version=v${version}
  '';

  meta = with lib; {
    description =
      "A vault for securely storing and accessing AWS credentials in development environments";
    homepage = "https://github.com/99designs/aws-vault";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
