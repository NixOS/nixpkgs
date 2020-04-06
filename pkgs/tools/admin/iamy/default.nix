{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "iamy";
  version = "2.3.2";

  goPackagePath = "github.com/99designs/iamy";

  src = fetchFromGitHub {
    owner = "99designs";
    repo = "iamy";
    rev = "v${version}";
    sha256 = "1fypc6yjnhlpk7zhb2lvah2ikh2zji9sll55rqjbr3i4j02h484z";
  };

  modSha256 = "0akak573zvz3xg5d7vf0ch2mrmj1jkzcdc29v3kn43f7944c2wcl";

  buildFlagsArray = [''-ldflags=
    -X main.Version=v${version} -s -w
  ''];

  meta = with stdenv.lib; {
    description = "A cli tool for importing and exporting AWS IAM configuration to YAML files";
    homepage = https://github.com/99designs/iamy;
    license = licenses.mit;
    maintainers = with maintainers; [ suvash ];
  };
}
