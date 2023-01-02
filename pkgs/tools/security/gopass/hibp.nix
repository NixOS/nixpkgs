{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, gopass
}:

buildGoModule rec {
  pname = "gopass-hibp";
  version = "1.15.2";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2F1OqVxXrQpwg2M1o8gQzczXI2JKVFCA1K6kGUc+e5U=";
  };

  vendorHash = "sha256-3KYEn4+YI5KwAlfokUF5hU801xylWVtmJwocVl6QfhM=";

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
