{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gotop";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "xxxserxxx";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3t6I4ah9gUmPlIBRL86BdgiUaMNiKNEeoUSRMASz1Yc=";
  };

  runVend = true;
  vendorSha256 = "sha256-GcIaUIuTiSY1aKxRtclfl7hMNaZZx4uoVG7ahjF/4Hs=";

  buildFlagsArray = [ "-ldflags=-s -w -X main.Version=v${version}" ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "A terminal based graphical activity monitor inspired by gtop and vtop";
    homepage = "https://github.com/xxxserxxx/gotop";
    changelog = "https://github.com/xxxserxxx/gotop/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}
