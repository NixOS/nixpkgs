{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gjo";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "skanehira";
    repo = "gjo";
    rev = version;
    sha256 = "07halr0jzds4rya6hlvp45bjf7vg4yf49w5q60mch05hk8qkjjdw";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "Small utility to create JSON objects";
    homepage = "https://github.com/skanehira/gjo";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
