{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "libgen-cli";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "ciehanski";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lfsnyzin2dqhwhz6phms6yipli88sqiw55ls18dfv7bvx30sqlp";
  };

  vendorSha256 = "1j45h8p13xfz0qy1nrddlx1xzbr5vqxd3q76hbb0v60636izfk0r";

  subPackages = [ "." ];

  meta = with lib; {
    homepage = "https://github.com/ciehanski/libgen-cli";
    description =
      "A CLI tool used to access the Library Genesis dataset; written in Go";
    longDescription = ''
      libgen-cli is a command line interface application which allows users to
      quickly query the Library Genesis dataset and download any of its
      contents.
    '';
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ zaninime ];
  };
}