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

  proxyVendor = true;
  vendorSha256 = "sha256-c+9IZEKiW95JIh6krs9NhdBohUatTTEIYBU13kj9zB8=";

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
    broken = stdenv.isDarwin; # needs to update gopsutil to at least v3.21.3 to include https://github.com/shirou/gopsutil/pull/1042
  };
}
