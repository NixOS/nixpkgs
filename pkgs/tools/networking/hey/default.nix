{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "hey";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "rakyll";
    repo = pname;
    rev = "v${version}";
    sha256 = "06w5hf0np0ayvjnfy8zgy605yrs5j326nk2gm0fy7amhwx1fzkwv";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "HTTP load generator, ApacheBench (ab) replacement";
    homepage = "https://github.com/rakyll/hey";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 ];
  };
}
