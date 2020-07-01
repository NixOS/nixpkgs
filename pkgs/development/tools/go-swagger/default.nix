{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "go-swagger";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "go-swagger";
    repo = pname;
    rev = "v${version}";
    sha256 = "051av25vnrcpvj9w6mqalwk7byw52m2dlh1m56y30xvm0ybbnayn";
  };

  vendorSha256 = "020z4izc8i4yhbbr8h2fn8bqbis9q9yfcrjnixd6rsiayw1brh4p";

  subPackages = [ "cmd/swagger" ];

  meta = with lib; {
    description = "Golang implementation of Swagger 2.0, representation of your RESTful API";
    homepage = "https://github.com/go-swagger/go-swagger";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
  };
}
