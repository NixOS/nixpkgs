{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "pwdsafety";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qnkabgc2924qg9x1ij51jq7lnxzcj1ygdp3x4mzi9gl532i191w";
  };

  vendorSha256 = "0avm4zwwqv476yrraaf5xkc1lac0mwnmzav5wckifws6r4x3xrsb";

  meta = with lib; {
    description = "Command line tool checking password safety";
    homepage = "https://github.com/edoardottt/pwdsafety";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
