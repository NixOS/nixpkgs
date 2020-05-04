{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "shfmt";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "sh";
    rev = "v${version}";
    sha256 = "0zlk1jjk65jwd9cx0xarz4yg2r2h86kd5g00gcnsav6dp6rx3aw8";
  };

  modSha256 = "080k8d5rp8kyg0x7vjxm758b9ya9z336yd4rcqws7yhqawxiv55z";
  subPackages = ["cmd/shfmt"];

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/mvdan/sh";
    description = "A shell parser and formatter";
    longDescription = ''
      shfmt formats shell programs. It can use tabs or any number of spaces to indent.
      You can feed it standard input, any number of files or any number of directories to recurse into.
    '';
    license = licenses.bsd3;
  };
}
