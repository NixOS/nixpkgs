{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "jwx";
  version = "2.0.11";

  src = fetchFromGitHub {
    owner = "lestrrat-go";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8ZzDVCJERf9T9Tlth+9imVJPZIAwffR03S/8UflKjZc=";
  };

  vendorHash = "sha256-RyAQh1uXw3bEZ6vuh8+mEf8T4l3ZIFAaFJ6dGMoANys=";

  sourceRoot = "source/cmd/jwx";

  meta = with lib; {
    description = " Implementation of various JWx (Javascript Object Signing and Encryption/JOSE) technologies";
    homepage = "https://github.com/lestrrat-go/jwx";
    license = licenses.mit;
    maintainers = with maintainers; [ arianvp flokli ];
  };
}
