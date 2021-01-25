{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "ffuf";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1jb2x0ybcb9zkqm7flpmr0hd3171xvnn6kxmfcgds4x8l9fbmxnr";
  };

  vendorSha256 = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";

  # tests don't pass due to an issue with the memory addresses
  # https://github.com/ffuf/ffuf/issues/367
  doCheck = false;

  meta = with lib; {
    description = "Fast web fuzzer written in Go";
    longDescription = ''
      FFUF, or “Fuzz Faster you Fool” is an open source web fuzzing tool,
      intended for discovering elements and content within web applications
      or web servers.
    '';
    homepage = "https://github.com/ffuf/ffuf";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
