{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "timescaledb-parallel-copy";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = pname;
    rev = "v${version}";
    sha256 = "0r8c78l8vg7l24c3vzs2qr2prfjpagvdkp95fh9gyz76nvik29ba";
  };

  vendorSha256 = "03siay3hv1sgmmp7w4f9b0xb8c6bnbx0v4wy5grjl5k04zhnj76b";

  meta = with lib; {
    description = "Bulk, parallel insert of CSV records into PostgreSQL";
    homepage = "https://github.com/timescale/timescaledb-parallel-copy";
    license = licenses.asl20;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
