{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "otpauth";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "dim13";
    repo = "otpauth";
    rev = "v${version}";
    sha256 = "sha256-qSu0kGRi1es9OciN1s9Eh1Z3JkxbcKO8W5cAC7c7n0k=";
  };

  vendorSha256 = "sha256-TU5crhmQAhSfURdfPe/xaa3RgGyc+UFn2E+jJ0flNsg=";
  doCheck = true;

  meta = with lib; {
    description = "Google Authenticator migration decoder";
    homepage = "https://github.com/dim13/otpauth";
    license = licenses.isc;
    maintainers = with maintainers; [ ereslibre ];
  };
}
