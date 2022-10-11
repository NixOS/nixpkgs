{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tlsx";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TqYBLNnh4wjinoduFrmyNe+FgnGSCckwMy5zX0XhnlM=";
  };

  vendorSha256 = "sha256-BppRtzTjiMcuc7xIz37bDcjnQHhOlstncES1vILTKYM=";

  meta = with lib; {
    description = "TLS grabber focused on TLS based data collection";
    longDescription = ''
      A fast and configurable TLS grabber focused on TLS based data
      collection and analysis.
    '';
    homepage = "https://github.com/projectdiscovery/tlsx";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
