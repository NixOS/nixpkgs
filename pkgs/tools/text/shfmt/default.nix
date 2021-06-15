{ lib, buildGoModule, fetchFromGitHub, installShellFiles, scdoc }:

buildGoModule rec {
  pname = "shfmt";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "sh";
    rev = "v${version}";
    sha256 = "sha256-pD1nkbBw5NBCyuhn2DYop2AR+1T8p6/zTa6FeWiya7Q=";
  };

  vendorSha256 = "sha256-euJYStN21xFYosouWYXpHN3MWCKR4NT8z6OSonM0HW8=";

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
    maintainers = with maintainers; [ zowoq SuperSandro2000 ];
  };
}
