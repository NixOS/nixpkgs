{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, fetchpatch
, installShellFiles
, IOKit
}:

buildGoModule rec {
  pname = "gotop";
  version = "4.1.4";

  src = fetchFromGitHub {
    owner = "xxxserxxx";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jAUlaj9Nv/ipzxAkG2myd9DIboHj7IarNMVk/FQ274g=";
  };

  patches = [
    # To remove after https://github.com/xxxserxxx/gotop/pull/234 is merged
    (fetchpatch {
      url = "https://github.com/xxxserxxx/gotop/commit/3e3243fa1f046c126bf9cb34d55a12963b3ac116.patch";
      sha256 = "sha256-4q4dBTPpVfgXvApzUXdEEzIe31PoLHUK4mBWth6qCIg=";
    })
  ];

  proxyVendor = true;
  vendorSha256 = "sha256-Sq9ol9bZb0BfR/C8phcMSEjG9qgWyTmwpo/TS30j3Vk=";

  ldflags = [ "-s" "-w" "-X main.Version=v${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ IOKit ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

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
  };
}
