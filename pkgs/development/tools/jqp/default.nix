{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "jqp";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "noahgorstein";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qN248U4Fx4IAjJegCUj98PzrypMp9PQEr2RUaKX3yE4=";
  };

  vendorHash = "sha256-qZTqqSANg0FpupWXTrHuYmnaTE387FhC40ZrZ9tlfew=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "A TUI playground to experiment with jq";
    homepage = "https://github.com/noahgorstein/jqp";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
