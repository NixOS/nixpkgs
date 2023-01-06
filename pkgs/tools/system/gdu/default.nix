{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, gdu
}:

buildGoModule rec {
  pname = "gdu";
  version = "5.21.0";

  src = fetchFromGitHub {
    owner = "dundee";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7zVYki4sA5jsnxWye0ouUwAOwKUBf/TiZDqFuXTm45w=";
  };

  vendorSha256 = "sha256-UP6IdJLc93gRP4vwKKOJl3sNt4sOFeYXjvwk8QM+D48=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/dundee/gdu/v${lib.versions.major version}/build.Version=${version}"
  ];

  postPatch = ''
    substituteInPlace cmd/gdu/app/app_test.go --replace "development" "${version}"
  '';

  postInstall = ''
    installManPage gdu.1
  '';

  doCheck = !stdenv.isDarwin;

  passthru.tests.version = testers.testVersion {
    package = gdu;
  };

  meta = with lib; {
    description = "Disk usage analyzer with console interface";
    longDescription = ''
      Gdu is intended primarily for SSD disks where it can fully
      utilize parallel processing. However HDDs work as well, but
      the performance gain is not so huge.
    '';
    homepage = "https://github.com/dundee/gdu";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.fab maintainers.zowoq ];
  };
}
