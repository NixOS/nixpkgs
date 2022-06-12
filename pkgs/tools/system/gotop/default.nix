{ lib, stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "gotop";
  version = "4.1.3";

  src = fetchFromGitHub {
    owner = "xxxserxxx";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-oDM+dpAT1vDpp2NkD669hwbgw7HWJGFqhsql9PvbxSk=";
  };

  proxyVendor = true;
  vendorSha256 = "sha256-WGLcpF1NqVQDiU3M9rQ555ZW3sDC3Szch+skTZgt0xg=";

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
