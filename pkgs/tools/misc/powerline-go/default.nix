{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "powerline-go";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "justjanne";
    repo = pname;
    rev = "v${version}";
    sha256 = "0dni842xzc8r6wbdfax25940jvxp69zk8xklczkjmyxqawvsxnjh";
  };

  vendorSha256 = "0dkgp9vlb76la0j439w0rb548qg5v8648zryk3rqgfhd4qywlk11";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A Powerline like prompt for Bash, ZSH and Fish";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sifmelcara ];
  };
}
