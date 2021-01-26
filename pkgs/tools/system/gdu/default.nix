{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "gdu";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "dundee";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ilaywj5vz8lgvm63j2saakhmgb2134idn6l8msbif4lsawlr313";
  };

  vendorSha256 = "058h71gmgi3n4b697myi5890arzw8fkzmxlm1aiwzyfh3k9iv0wh";

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
