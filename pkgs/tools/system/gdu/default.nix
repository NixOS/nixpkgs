{ stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gdu";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "dundee";
    repo = pname;
    rev = "v${version}";
    sha256 = "0239ppiilr8d43z9v27c9h7b5xkj2n9aacpf5a0h3rz4j0dkcwf7";
  };

  vendorSha256 = "1jqbsda9bch3awdq816w4jybv7wz9mfflmvs5y2wsa2qnhn9nbyp";

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
