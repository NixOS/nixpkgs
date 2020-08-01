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

  vendorSha256 = "0c4g1zr0wl118g41hqri0vwvfin39yvgs214w3spw8ggjcj6bzph";

  buildFlagsArray = [''-ldflags=
    -X main.Version=v${version} -s -w
  ''];

  meta = with stdenv.lib; {
    description = "A cli tool for importing and exporting AWS IAM configuration to YAML files";
    homepage = "https://github.com/99designs/iamy";
    license = licenses.mit;
    maintainers = with maintainers; [ suvash ];
  };
}
