{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "certigo";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "square";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3VysSE4N2MlNDOZ27RbCe8rUuYChU5Z3L/CIhtvMp38=";
  };

  vendorSha256 = "sha256-0wul0f8T7E4cXbsNee1j1orUgjrAToqDLgwCjiyii1Y=";

  doCheck = false;

  meta = with lib; {
    description = "A utility to examine and validate certificates in a variety of formats";
    homepage = "https://github.com/square/certigo";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
