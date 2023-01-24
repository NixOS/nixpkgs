{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, gopass
}:

buildGoModule rec {
  pname = "gopass-hibp";
  version = "1.15.3";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KqW1q3CnniNeQFypeZ6x/ov58SOMfAX5P2MMDKjMYBg=";
  };

  vendorHash = "sha256-w1Kxocrwcgn0g6ZBJ7obHraHK397bJltUFkm+/p4H5Y=";

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s" "-w" "-X main.version=${version}" "-X main.commit=${src.rev}"
  ];

  postFixup = ''
    wrapProgram $out/bin/gopass-hibp \
      --prefix PATH : "${lib.makeBinPath [ gopass ]}"
  '';

  meta = with lib; {
    description = "Gopass haveibeenpwnd.com integration";
    homepage = "https://www.gopass.pw/";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
  };
}
