{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "gdu";
  version = "5.16.0";

  src = fetchFromGitHub {
    owner = "dundee";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-e2fZJ1HRoi2uMyCWgjPIXs6Q6neg8XEqtC8YcUev+60=";
  };

  vendorSha256 = "sha256-42hXOF/jeOc7WXqq6nBgYv5Qjypszxp9IboxchKQbN8=";

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
    maintainers = [ maintainers.fab maintainers.zowoq ];
    platforms = platforms.unix;
  };
}
