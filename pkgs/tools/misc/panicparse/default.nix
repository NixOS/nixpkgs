{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "panicparse";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "maruel";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Bwvxj9Ifcq2WpicUBK+03fbGuoVAVF2Zmtpy/utUxoo=";
  };

  vendorSha256 = "sha256-ZHUxzGqsGX1c4mBA4TBO2+WnGDhwAOGi0uYQx+3OgL8=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Crash your app in style (Golang)";
    homepage = "https://github.com/maruel/panicparse";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
