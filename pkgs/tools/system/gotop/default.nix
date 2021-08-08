{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gotop";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "xxxserxxx";
    repo = pname;
    rev = "v${version}";
    sha256 = "15bsxaxqxp17wsr0p9fkpvgfyqnhhwm3j8jxkvcs4cdw73qaxdsy";
  };

  runVend = true;
  vendorSha256 = "06hl1npwmy9dvpf4kljvw8lwwiigm52wf106lmf9k6k2gi5ikprz";

  ldflags = [ "-s" "-w" "-X main.Version=v${version}" ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "A terminal based graphical activity monitor inspired by gtop and vtop";
    homepage = "https://github.com/xxxserxxx/gotop";
    changelog = "https://github.com/xxxserxxx/gotop/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.magnetophon ];
  };
}
