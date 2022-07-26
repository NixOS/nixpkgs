{ lib, stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "gotop";
  version = "4.1.4";

  src = fetchFromGitHub {
    owner = "xxxserxxx";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jAUlaj9Nv/ipzxAkG2myd9DIboHj7IarNMVk/FQ274g=";
  };

  proxyVendor = true;
  vendorSha256 = "sha256-y4hVouvqMYUrdF7fowsvJLp0FCGCZDeVGUQXG8z8Lyg=";

  ldflags = [ "-s" "-w" "-X main.Version=v${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  doCheck = !stdenv.isDarwin;

  postInstall = ''
    $out/bin/gotop --create-manpage > gotop.1
    installManPage gotop.1
  '';

  meta = with lib; {
    description = "A terminal based graphical activity monitor inspired by gtop and vtop";
    homepage = "https://github.com/xxxserxxx/gotop";
    changelog = "https://github.com/xxxserxxx/gotop/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.magnetophon ];
    broken = stdenv.isDarwin; # needs to update gopsutil to at least v3.21.3 to include https://github.com/shirou/gopsutil/pull/1042
  };
}
