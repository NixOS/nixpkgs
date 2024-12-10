{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ruler";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "sensepost";
    repo = pname;
    rev = version;
    hash = "sha256-cEYpK1LB9b65xr6MCMax1vUtSWefjJdXNs4sPgx65d0=";
  };

  vendorHash = "sha256-ITd3cvZmRBWK3922dDRvNHNH8KzHoVfIQI6S318ibxA=";

  meta = with lib; {
    description = "Tool to abuse Exchange services";
    homepage = "https://github.com/sensepost/ruler";
    license = with licenses; [ cc-by-nc-40 ];
    maintainers = with maintainers; [ fab ];
  };
}
