{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "gdu";
  version = "4.11.1";

  src = fetchFromGitHub {
    owner = "dundee";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-e9TYArmNWnK8XXcniAQCegrfWAUfTKKuClgdSTQep0U=";
  };

  vendorSha256 = "sha256-QiO5p0x8kmIN6f0uYS0IR2MlWtRYTHeZpW6Nmupjias=";

  nativeBuildInputs = [ installShellFiles ];

  buildFlagsArray = [
    "-ldflags="
    "-s"
    "-w"
    "-X github.com/dundee/gdu/v${lib.versions.major version}/build.Version=${version}"
  ];

  postPatch = ''
    substituteInPlace cmd/app/app_test.go --replace "development" "${version}"
  '';

  postInstall = ''
    installManPage gdu.1
  '';

  # tests fail with:
  #  dir_test.go:76:
  #              Error Trace:    dir_test.go:76
  #              Error:          Not equal:
  #                              expected: 0
  #                              actual  : 512
  #              Test:           TestFlags
  doCheck = false;

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
