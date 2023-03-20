{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "countryfetch";
  version = "unstable-2023-03-11"; 

  src = fetchFromGitHub {
    owner = "CondensedMilk7";
    repo = pname;
    rev = "6ad9f39743f73e61a749e535a00dade5158744b7";
    sha256 = "1qiv1r6rs0xax964khsb7v7hz0r2siy94gyy420qgak3rpjs8mwg"; 
  };

  vendorSha256 = "hHojtd0UZAov1mhNCudWm2GVEVlKqGculxaszwfea5Q=";

  subPackages = [ "cmd/countryfetch" ];

  meta = with lib; {
    description = "A CLI tool to fetch information about countries";
    homepage = "https://github.com/CondensedMilk7/countryfetch";
    license = licenses.mit;
    maintainers = with maintainers; [ xel ];
    platforms = platforms.unix;
  };
}
