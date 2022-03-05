{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dismap";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "zhzyker";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WaQdDcBvv4mHdPFAB+spC64YeT3jlfyMYNsTjBILjwA=";
  };

  vendorSha256 = "sha256-GnchyE2TswvjYlehhMYesZruTTwyTorfR+17K0RXXFY=";

  meta = with lib; {
    description = "Asset discovery and identification tools";
    homepage = "https://github.com/zhzyker/dismap";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
