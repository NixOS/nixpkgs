{ buildGoModule
, fetchFromGitHub
, lib, stdenv
}:

buildGoModule rec {
  pname = "gospider";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "jaeles-project";
    repo = pname;
    rev = version;
    sha256 = "03gl8y2047iwa6bhmayyds3li21wy3sw1x4hpp9zgqgi95039q86";
  };

  vendorSha256 = "0dc4ddi26i38c5rvy9zbal27a7qvn17h64w1yhbig4iyb79b18ym";

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
