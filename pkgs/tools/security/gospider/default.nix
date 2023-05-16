{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gospider";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "jaeles-project";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1EnKheHaS1kxw0cjxCahT3rUWBXiqxjKefrDBI2xIvY=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-egjjSEZH8F6UMbnkz3xytIzdW/oITB3RL1ddxrmvSZM=";
=======
  vendorSha256 = "sha256-egjjSEZH8F6UMbnkz3xytIzdW/oITB3RL1ddxrmvSZM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
