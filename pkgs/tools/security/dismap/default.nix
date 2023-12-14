{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dismap";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "zhzyker";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YjjiS6iLIQvrPS378v2nyrgwWBJ9YtDeNTPz0ze05mU=";
  };

  vendorHash = "sha256-GnchyE2TswvjYlehhMYesZruTTwyTorfR+17K0RXXFY=";

  meta = with lib; {
    description = "Asset discovery and identification tools";
    homepage = "https://github.com/zhzyker/dismap";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
