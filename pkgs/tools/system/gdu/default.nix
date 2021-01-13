{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gdu";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "dundee";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ajkc0vbzyl56d6z03s5vb17frjrg5wl145x60asnrmh7lg8adsj";
  };

  vendorSha256 = "1jqbsda9bch3awdq816w4jybv7wz9mfflmvs5y2wsa2qnhn9nbyp";

  buildFlagsArray = [ "-ldflags=-s -w -X main.AppVersion=${version}" ];

  # analyze/dev_test.go: undefined: processMounts
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
