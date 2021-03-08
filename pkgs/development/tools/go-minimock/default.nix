{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-minimock";
  version = "3.0.8";

  src = fetchFromGitHub {
    owner = "gojuno";
    repo = "minimock";
    rev = "v${version}";
    sha256 = "0r0krbwvx5w1z0yv2qqi92irbsfhkvwvaigy350cvcz9gmcppj4h";
  };

  vendorSha256 = "1macwm6hybjinwnx62v146yxydcn5k5r587nxwkf4ffy76s2m3jc";

  doCheck = true;

  subPackages = [ "cmd/minimock" "." ];

  meta = with lib; {
    homepage = "https://github.com/gojuno/minimock";
    description = "A golang mock generator from interfaces";
    license = licenses.mit;
    maintainers = with maintainers; [ svrana ];
  };
}
