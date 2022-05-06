{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "htmltest";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "wjdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Om3jnaHFEq8XJZhGolPax2NH7PFqtqMG5Rd7JTBdGf8=";
  };

  vendorSha256 = "0zx3ii9crick647kslzwg4d39li6jds938f9j9dp287rhrlzjfbm";

  ldflags = [
    "-w"
    "-s"
    "-X main.version=${version}"
  ];

  # tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Tool to test generated HTML output";
    longDescription = ''
      htmltest runs your HTML output through a series of checks to ensure all your
      links, images, scripts references work, your alt tags are filled in, etc.
    '';
    homepage = "https://github.com/wjdp/htmltest";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
