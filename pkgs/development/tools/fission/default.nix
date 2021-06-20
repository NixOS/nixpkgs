{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "fission";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "fission";
    repo = "fission";
    rev = version;
    sha256 = "sha256-WCynU5+d789d584JH99jmTZSEbyco2ysuBXIC2pW1r4=";
  };

  vendorSha256 = "sha256-V3/IFCbW3wXfNiFzucLeyFDc6SA2nE+NwO0sNEBmIYg=";

  buildFlagsArray = "-ldflags=-s -w -X info.Version=${version}";

  subPackages = [ "cmd/fission-cli" ];

  postInstall = ''
    ln -s $out/bin/fission-cli $out/bin/fission
  '';

  meta = with lib; {
    description = "The cli used by end user to interact Fission";
    homepage = "https://fission.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ neverbehave ];
  };
}
