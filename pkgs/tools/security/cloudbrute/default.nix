{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "cloudbrute";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "0xsha";
    repo = "CloudBrute";
    rev = "v${version}";
    sha256 = "05b9klddk8wvi78j47jyg9pix6qpxyr01l1m7k1j7598siazfv9g";
  };

  vendorSha256 = "0f3n0wrmg9d2qyn8hlnhf9lsfqd9443myzr04p48v68m8n83j6a9";

  meta = with lib; {
    description = "Cloud enumeration tool";
    longDescription = ''
      A tool to find a company (target) infrastructure, files, and apps on
      the top cloud providers (Amazon, Google, Microsoft, DigitalOcean,
      Alibaba, Vultr, Linode).
    '';
    homepage = "https://github.com/0xsha/CloudBrute";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
