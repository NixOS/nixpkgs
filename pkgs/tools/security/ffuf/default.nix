{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "ffuf";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "ffuf";
    repo = "ffuf";
    rev = "v${version}";
    sha256 = "1jb2x0ybcb9zkqm7flpmr0hd3171xvnn6kxmfcgds4x8l9fbmxnr";
  };

  vendorSha256 = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";

  doCheck = false;

  meta = with lib; {
    description = "A fast web fuzzer written in Go";
    homepage = "https://github.com/ffuf/ffuf";
    license = licenses.mit;
    maintainers = with maintainers; [ htr ];
  };
}
