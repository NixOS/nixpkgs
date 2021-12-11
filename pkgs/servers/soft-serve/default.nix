{ lib, buildGoModule, fetchFromGitHub, makeWrapper, git }:

buildGoModule rec {
  pname = "soft-serve";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "soft-serve";
    rev = "v${version}";
    sha256 = "0z88699q34a9cbhcz12y2qs2qrspfd8yx4ay0r8jzvkgax9ylrlk";
  };

  vendorSha256 = "1g2iznfh08l23i81x7g2bhc7l8cppshzlyynxik4jshswlpv80sr";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/soft \
      --prefix PATH : "${lib.makeBinPath [ git ]}"
  '';

  meta = with lib; {
    description = "A tasty, self-hosted Git server for the command line";
    homepage = "https://github.com/charmbracelet/soft-serve";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
