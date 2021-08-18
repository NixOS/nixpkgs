{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "otpauth";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "dim13";
    repo = "otpauth";
    rev = "v${version}";
    sha256 = "199kh544kx4cbsczc9anmciczi738gdc5g518ybb05h49vlb51dp";
  };

  runVend = true;
  vendorSha256 = "1762cchqydgsf94y05dwxcrajvjr64ayi5xk1svn1xissyc7vgpv";
  doCheck = true;

  meta = with lib; {
    description = "Google Authenticator migration decoder";
    homepage = "https://github.com/dim13/otpauth";
    license = licenses.isc;
    maintainers = with maintainers; [ ereslibre ];
  };
}
