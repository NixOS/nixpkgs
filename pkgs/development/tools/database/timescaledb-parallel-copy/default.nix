{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "timescaledb-parallel-copy";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HxaGKJnLZjPPJXoccAx0XUsCrZiG09c40zeSbHYXm04=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-muxtr80EjnRoHG/TCEQwrBwlnARsfqWoYlR0HavMe6U=";
=======
  vendorSha256 = "sha256-muxtr80EjnRoHG/TCEQwrBwlnARsfqWoYlR0HavMe6U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Bulk, parallel insert of CSV records into PostgreSQL";
    homepage = "https://github.com/timescale/timescaledb-parallel-copy";
    license = licenses.asl20;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
