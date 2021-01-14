{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gdu";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "dundee";
    repo = pname;
    rev = "v${version}";
    sha256 = "1dc0z6daxpbid2ilpms0dw76qyyc84gx0bcqsx0b3s5p5p154xzq";
  };

  vendorSha256 = "18a3qwshz8jmw0j29qvmzarxig0kj1n0fnmlx81qzswsyl85kncv";

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
