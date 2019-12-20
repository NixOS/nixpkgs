{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "dua";
  version = "2.1.11";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "dua-cli";
    rev = "v${version}";
    sha256 = "08zgi2yiynb20l1f9rhly4a7zgqnr7lq3cr5vkmh1jnfs6z27dv6";
  };

  cargoSha256 = "0hd46h4wwh81hnida0in3142884y8n6ygk7qm09i5wj52g73bivv";

  meta = with lib; {
    description = "A tool to conveniently learn about the disk usage of directories, fast!";
    homepage = "https://github.com/Byron/dua-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ killercup ];
    platforms = platforms.all;
  };
}
