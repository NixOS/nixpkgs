{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "choose";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "theryangeary";
    repo = pname;
    rev = "v${version}";
    sha256 = "0j3861pxqw0lnamb201c7h5w7npzyiwwb6c1xzxjv72m2ccvz76j";
  };

  cargoSha256 = "1xlqz2z0244mk1p1njx6gga8p0p9cq6ihacj4vy7dm2zm46il5ka";

  meta = with lib; {
    description = "A human-friendly and fast alternative to cut and (sometimes) awk";
    homepage = "https://github.com/theryangeary/choose";
    license = licenses.gpl3;
    maintainers = with maintainers; [ sohalt ];
  };
}
