{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "shfmt";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "sh";
    rev = "v${version}";
    sha256 = "03zgi0rlra3gz8cbqwmhpjxsg5048anfc6ccd2w50fjhx6farsnv";
  };

  vendorSha256 = "1jq2x4yxshsy4ahp7nrry8dc9cyjj46mljs447rq57sgix4ndpq8";

  subPackages = [ "cmd/shfmt" ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mvdan/sh";
    description = "A shell parser and formatter";
    longDescription = ''
      shfmt formats shell programs. It can use tabs or any number of spaces to indent.
      You can feed it standard input, any number of files or any number of directories to recurse into.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ zowoq ];
  };
}
