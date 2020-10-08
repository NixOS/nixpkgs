{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

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

  patches = [
    # fix failing test on go 1.15, remove with > 3.1.2
    (fetchpatch {
      url = "https://github.com/mvdan/sh/commit/88956f97dae1f268af6c030bf2ba60762ebb488a.patch";
      sha256 = "1zg8i7kklr12zjkaxh8djd2bzkdx8klgfj271r2wivkc2x61shgv";
    })
  ];

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
