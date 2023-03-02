{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tailspin";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = pname;
    rev = version;
    sha256 = "sha256-f9VfOcLOWJ4yr/CS0lqaqiaTfzOgdoI9CaS70AMNdsc=";
  };

  vendorHash = "sha256-gn7/pFw7JEhkkd/PBP4jLUKb5NBaRE/rb049Ic/Bu7A=";

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
