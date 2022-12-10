{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "jqp";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "noahgorstein";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-f1HSwo0TwNpw02bNT1dzfovXcRQuP/IxAmomBgKuQxQ=";
  };

  vendorSha256 = "sha256-cx5esdxAJInxXHXx0xeKQNGTDBjKD3GhnY0Fu/Tzy9U=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "A TUI playground to experiment with jq";
    homepage = "https://github.com/noahgorstein/jqp";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
