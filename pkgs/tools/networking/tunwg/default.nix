{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tunwg";
  version = "23.07.15+3213668";

  src = fetchFromGitHub {
    owner = "ntnj";
    repo = "tunwg";
    rev = "v${version}";
    hash = "sha256-FghsfL3GW8jWBICJWXsqiFZPbDhIKl2nY8RsMH6ILTw=";
  };

  vendorHash = "sha256-pzUWhKcht9vodBiZGe9RU+tm0c1/slBGeIrKfZlIDdk=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Secure private tunnel to your local servers";
    homepage = "https://github.com/ntnj/tunwg";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
