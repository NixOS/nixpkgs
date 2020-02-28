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

  modSha256 = "0a00kcyagqczw0vhl8qs2xs1y8myw080y9kjs4qrcmj6kibdy55q";

  meta = with lib; {
    description = "HTTP load generator, ApacheBench (ab) replacement";
    homepage = "https://github.com/rakyll/hey";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 ];
  };
}
