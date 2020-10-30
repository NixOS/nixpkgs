{ lib, buildGoModule, fetchFromGitHub, installShellFiles, scdoc }:

buildGoModule rec {
  pname = "shfmt";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "sh";
    rev = "v${version}";
    sha256 = "1ybrx82c4djp7izyqhvzk0rcf9ac7nv5g5ahxr0k0jhm752ba5z2";
  };

  vendorSha256 = "1ma7nvyn6ylbi8bd7x900i94pzs877kfy9xh0nf1bbify1vcpd29";

  subPackages = [ "cmd/shfmt" ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  nativeBuildInputs = [ installShellFiles scdoc ];

  postBuild = ''
    scdoc < cmd/shfmt/shfmt.1.scd > shfmt.1
    installManPage shfmt.1
  '';

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
