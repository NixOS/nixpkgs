{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, d2
}:

buildGoModule rec {
  pname = "d2";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "terrastruct";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-O3T26Stau168hP7Hhv2bayamXQvaFD6feyW5AYoHf0U=";
  };

  vendorHash = "sha256-k9zaZ28vs3R5usWUW5N78zz0PuP5UrYEhgXxpQ+v5sE=";

  ldflags = [
    "-s"
    "-w"
    "-X oss.terrastruct.com/d2/lib/version.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage ci/release/template/man/d2.1
  '';

  subPackages = [ "." ];

  passthru.tests.version = testers.testVersion { package = d2; };

  meta = with lib; {
    description = "A modern diagram scripting language that turns text to diagrams";
    homepage = "https://d2lang.com";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
