{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, yara
}:

buildGoModule rec {
  pname = "spyre";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "spyre-project";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wlGZTMCJE6Ki5/6R6J9EJP06/S125BNNd/jNPYGwKNw=";
  };

  vendorHash = "sha256-qZkt5WwicDXrExwMT0tCO+FZgClIHhrVtMR8xNsdAaQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    yara
  ];

  meta = with lib; {
    description = "YARA-based IOC scanner";
    homepage = "https://github.com/spyre-project/spyre";
    license = with licenses; [ lgpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
