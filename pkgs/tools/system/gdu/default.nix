{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "gdu";
  version = "4.6.3";

  src = fetchFromGitHub {
    owner = "dundee";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vz8qqsFc1CETnrqStLyiGZ6w0jy+y5GlwQQgxdyJ5aY=";
  };

  vendorSha256 = "sha256-kIMd0xzQ+c+jCpX2+qdD/GcFEirR15PMInbEV184EBU=";

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/dundee/gdu/build.Version=${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage gdu.1
  '';

  # tests fail if the version is set
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
