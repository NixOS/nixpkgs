{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "htmltest";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "wjdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "0z2j54ywim1nl10vidcnbwhywyzanj4qd93ai533808wrm3ghwb6";
  };

  vendorSha256 = "0zx3ii9crick647kslzwg4d39li6jds938f9j9dp287rhrlzjfbm";

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
