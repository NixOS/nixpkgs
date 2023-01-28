{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dbmate";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    rev = "v${version}";
    sha256 = "sha256-6M7ruiBjvXO6LTdZNuGwUIVwa3QzdBQo0Y34UslCGAE=";
  };

  vendorSha256 = "sha256-DwQUrNBfKZaVIpqI8yI/C9CQF5Ok/sApOrsLeIxt3hM=";

  doCheck = false;

  meta = with lib; {
    description = "Database migration tool";
    homepage = "https://github.com/amacneil/dbmate";
    license = licenses.mit;
    maintainers = [ maintainers.manveru ];
    platforms = platforms.unix;
  };
}
