{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gdu";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "dundee";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sfb8bxvdd8r05d0bgfcaw6dpbky7f4fgf0dbly7k7sgl29hkafy";
  };

  vendorSha256 = "0w3k23kly8g9mf8a300xz6bv7g1m2nlp5f112k4viyi9zy6vqbv0";

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/dundee/gdu/build.Version=${version}" ];

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
