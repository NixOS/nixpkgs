{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "pet";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "knqyf263";
    repo = "pet";
    rev = "v${version}";
    sha256 = "1na3az7vicjq1rxd3ybid47yrblsdazgli0dchkbwh8zchwhqj33";
  };

  vendorSha256 = "0pnd89iqdj3f719xf4iy5r04n51d0rrrf0qb2zjirpw7vh7g82i9";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Simple command-line snippet manager, written in Go";
    homepage = "https://github.com/knqyf263/pet";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
