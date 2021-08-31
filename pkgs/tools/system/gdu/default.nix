{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "gdu";
  version = "5.6.2";

  src = fetchFromGitHub {
    owner = "dundee";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9Qdl+5BvzYbBw90+9V5bKBrikxlxMt7UxMQ54XwgbTk=";
  };

  vendorSha256 = "sha256-TxtYsM1qtpvI5IbkM3vicCgJ0+EqelFJ8Vc6+Ff5wd8=";

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

  meta = with lib; {
    description = "Disk usage analyzer with console interface";
    longDescription = ''
      Gdu is intended primarily for SSD disks where it can fully
      utilize parallel processing. However HDDs work as well, but
      the performance gain is not so huge.
    '';
    homepage = "https://github.com/dundee/gdu";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.fab ];
    platforms = platforms.unix;
  };
}
