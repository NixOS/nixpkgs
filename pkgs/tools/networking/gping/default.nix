{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "gping";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    rev = "v${version}";
    sha256 = "10hvzgn98qbzs7mmql9wlbll814mkki29lvg71lbvr81wlbdn6mr";
  };

  cargoSha256 = "0kkfrdzyy5068k8nz08pfc4cl1dvn0vd6i01gax5dblk122ybbag";

  meta = with lib; {
    description = "Ping, but with a graph";
    homepage = "https://github.com/orf/gping";
    license = licenses.mit;
    maintainers = with maintainers; [ andrew-d ];
  };
}
