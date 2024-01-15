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
    hash = "sha256-L233VdQolSPDPDXQALLvF5seb3peHiLRiZuj2RqdaRU=";
  };

  vendorHash = "sha256-SRk5kEUVmY3IJSB/XwchqWGnaXLQUoisx6KlVzMHdjg=";

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
