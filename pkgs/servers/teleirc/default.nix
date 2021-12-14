{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "teleirc";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "RITlug";
    repo = "teleirc";
    rev = "v${version}";
    sha256 = "sha256-4ySphoMwHMjbctKEpgm6t6lOZSLsvKhAltyxRDDj0ww=";
  };

  vendorSha256 = "sha256-mum49SL5aMuSOPKBbmjb0JOVj9XN3GsnH0fCu7rnwhk=";

  subPackages = [ "cmd" ];

  meta = with lib; {
    description = "Telegram - IRC bridge";
    homepage = "https://docs.teleirc.com";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}
