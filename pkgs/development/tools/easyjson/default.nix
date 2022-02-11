{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage {
  pname = "easyjson";
  version = "unstable-2019-06-26";
  goPackagePath = "github.com/mailru/easyjson";

  src = fetchFromGitHub {
    owner = "mailru";
    repo = "easyjson";
    rev = "b2ccc519800e761ac8000b95e5d57c80a897ff9e";
    sha256 = "0q85h383mhbkcjm2vqm72bi8n2252fv3c56q3lclzb8n2crnjcdk";
  };

  meta = with lib; {
    homepage = "https://github.com/mailru/easyjson";
    description = "Fast JSON serializer for golang";
    license = licenses.mit;
    maintainers = with maintainers; [ chiiruno ];
  };
}
