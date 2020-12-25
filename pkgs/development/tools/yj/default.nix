{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "yj";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "sclevine";
    repo = "yj";
    rev = "c4c13b7641389c76ea028b48091f851f3efb6376";
    sha256 = "0bnb88wfm2vagh4yb1h9xhp3045ga0b6a77n3j2z5b4mvwshx5dr";
  };

  vendorSha256 = "0y0n9fsb85qlpf9slwsxzarmfi98asa4x04qp2r8pagl28l0i8wv";

  buildFlagsArray = [ "-ldflags=-s -w -X main.Version=${version}" ];

  meta = with stdenv.lib; {
    description = ''Convert YAML <=> TOML <=> JSON <=> HCL'';
    license = licenses.asl20;
    maintainers = with maintainers; [ Profpatsch ];
    homepage = "https://github.com/sclevine/yj";
  };
}
