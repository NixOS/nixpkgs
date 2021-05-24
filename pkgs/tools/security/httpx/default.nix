{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "httpx";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "httpx";
    rev = "v${version}";
    sha256 = "sha256-zwQDPOpctnAj6J6mQ4N7O1KJiAIu6osB/IlnM0D/hZA=";
  };

  vendorSha256 = "sha256-Cb7RomQ/+O9xgUlCudoj7zLd2vrs58d00/vk/EboJ6Q=";

  meta = with lib; {
    description = "Fast and multi-purpose HTTP toolkit";
    longDescription = ''
      httpx is a fast and multi-purpose HTTP toolkit allow to run multiple
      probers using retryablehttp library, it is designed to maintain the
      result reliability with increased threads.
    '';
    homepage = "https://github.com/projectdiscovery/httpx";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
