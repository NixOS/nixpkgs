{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tlsx";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DcC08KmSXYOk4jlU0KIdu5zziWZLYlWetN+/ZGaY4RQ=";
  };

  vendorHash = "sha256-BppRtzTjiMcuc7xIz37bDcjnQHhOlstncES1vILTKYM=";

  meta = with lib; {
    description = "TLS grabber focused on TLS based data collection";
    longDescription = ''
      A fast and configurable TLS grabber focused on TLS based data
      collection and analysis.
    '';
    homepage = "https://github.com/projectdiscovery/tlsx";
    changelog = "https://github.com/projectdiscovery/tlsx/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
