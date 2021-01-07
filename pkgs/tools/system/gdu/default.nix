{ stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gdu";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "dundee";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gk36z8xzj7blwzs080fqsz76hn56c89xcsyil6n5cfkbyf85c6i";
  };

  vendorSha256 = "1jqbsda9bch3awdq816w4jybv7wz9mfflmvs5y2wsa2qnhn9nbyp";

  buildFlagsArray = [ "-ldflags=-s -w -X main.AppVersion=${version}" ];

  meta = with stdenv.lib; {
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
