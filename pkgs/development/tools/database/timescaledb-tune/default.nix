{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "timescaledb-tune";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vrbbswmg6z3n012mqd1jasqk01navypzv5m00r6c9bxj72hgcxl";
  };

  vendorSha256 = "0hbpprbxs19fcar7xcy42kn9yfzhal2zsv5pml9ghiv2s61yns4z";

  meta = with stdenv.lib; {
    description = "A tool for tuning your TimescaleDB for better performance";
    homepage = "https://github.com/timescale/timescaledb-tune";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
