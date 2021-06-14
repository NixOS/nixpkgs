{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "gospider";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "jaeles-project";
    repo = pname;
    rev = version;
    sha256 = "sha256-yfW94sQzT1u6O0s1sqpeANlukC5y8fNvHNL2c77+dxU=";
  };

  vendorSha256 = "sha256-1aOw0lk+khcX9IETA0+wGx91BFXrJ79zYWhEI2JrhDU=";

  # tests require internet access and API keys
  doCheck = false;

  meta = with lib; {
    description = "Fast web spider written in Go";
    longDescription = ''
      GoSpider is a fast web crawler that parses sitemap.xml and robots.txt file.
      It can generate and verify link from JavaScript files, extract URLs from
      various sources and can detect subdomains from the response source.
    '';
    homepage = "https://github.com/jaeles-project/gospider";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
