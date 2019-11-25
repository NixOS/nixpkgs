{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "vegeta";
  version = "12.7.0";

  goPackagePath = "github.com/tsenart/vegeta";
  modSha256 = "1wzx9588hjzxq65fxi1zz9xpsw33qq41hpl0j2f077g4m8yxahv5";

  src = fetchFromGitHub {
    owner = "tsenart";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wzx9588hjzxq65fxi1zz9xpsw33qq41hpl0j2f077g4m8yxahv5";
  };

  meta = with lib; {
    description = "Versatile HTTP load testing tool";
    homepage = "https://github.com/tsenart/vegeta";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}
