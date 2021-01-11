{ buildGoModule
, fetchFromGitHub
, lib, stdenv
}:

buildGoModule rec {
  pname = "dnsx";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "dnsx";
    rev = "v${version}";
    sha256 = "1pgq21pbnz2dm272zrhd455njj5vg4kywpd230acj675nlgir6y1";
  };

  vendorSha256 = "0j2cqvskzxbyfrvsv4gm4qwfjm0digizcg157z5iignnknddajax";

  meta = with lib; {
    description = "Fast and multi-purpose DNS toolkit";
    longDescription = ''
      dnsx is a fast and multi-purpose DNS toolkit allow to run multiple
      probers using retryabledns library, that allows you to perform
      multiple DNS queries of your choice with a list of user supplied
      resolvers.
    '';
    homepage = "https://github.com/projectdiscovery/dnsx";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
