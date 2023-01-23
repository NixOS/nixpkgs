{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "vultr";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "JamesClonk";
    repo = "vultr";
    rev = "v${version}";
    sha256 = "sha256-kyB6gUbc32NsSDqDy1zVT4HXn0pWxHdBOEBOSaI0Xro=";
  };

  vendorSha256 = null;

  # There are not test files
  doCheck = false;

  meta = with lib; {
    description = "Vultr CLI and API client library";
    homepage = "https://jamesclonk.github.io/vultr";
    changelog = "https://github.com/JamesClonk/vultr/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ zauberpony ];
  };
}
