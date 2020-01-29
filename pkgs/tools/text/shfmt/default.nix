{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "shfmt";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "sh";
    rev = "v${version}";
    sha256 = "1y6n2xi8m579xksnnsdzb4zvcvij48kywjfqzp7qm43ni8g7w9a8";
  };

  modSha256 = "1ll2cxhgf8hh19wzdykgc81c4yfcp8bzmfaif08nvvb63rhjdb5y";
  subPackages = ["cmd/shfmt"];

  meta = with stdenv.lib; {
    homepage = https://github.com/mvdan/sh;
    description = "A shell parser and formatter";
    longDescription = ''
      shfmt formats shell programs. It can use tabs or any number of spaces to indent.
      You can feed it standard input, any number of files or any number of directories to recurse into.
    '';
    license = licenses.bsd3;
  };
}
