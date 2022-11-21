{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tailspin";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = pname;
    rev = version;
    sha256 = "sha256-ReWgbAmEGpNOv6QArNT+eWaty88tChhH1nhH0vZe2/E=";
  };

  vendorSha256 = "sha256-rZJO/TSGrYwrtIKQpKhZZqnXY6IHNyjS26vBDv/iQ34=";

  CGO_ENABLED = 0;

  subPackages = [ "." ];

  meta = with lib; {
    description = "A log file highlighter and a drop-in replacement for `tail -f`";
    homepage = "https://github.com/bensadeh/tailspin";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "spin";
  };
}
