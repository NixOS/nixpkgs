{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, gopass
}:

buildGoModule rec {
  pname = "gopass-hibp";
  version = "1.15.5";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass-hibp";
    rev = "v${version}";
    hash = "sha256-BHMhQqaYM0WfCzvDo7X1GEVNv44zEw2KeA9jhF7RgC4=";
  };

  vendorHash = "sha256-Y6BMzSRzbORIbebfP+ptIswyOclM1bs1zPmLpqko//4=";

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
