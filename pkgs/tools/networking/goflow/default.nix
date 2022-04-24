{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "goflow";
  version = "3.4.3";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dUoiuoM87Bh3ndzHG/YnwnRWnVbtPDuVdICEXcezCp8=";
  };

  vendorSha256 = "sha256-fOlfVI8v7KqNSRhAPlZBSHKfZRlCbCgjnMV/6bsqDhg=";

  meta = with lib; {
    description = "A NetFlow/IPFIX/sFlow collector in Go";
    homepage = "https://github.com/cloudflare/goflow";
    license = licenses.bsd3;
    maintainers = with maintainers; [ heph2 ];
    platforms = platforms.all;
  };
}
