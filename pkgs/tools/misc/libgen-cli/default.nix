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

  modSha256 = "1k16zjb7p65g72hr9vsk38jhpsy1yclm7fjgq47qy6jwjd44w1bi";

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
