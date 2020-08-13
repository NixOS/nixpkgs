{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mcfly";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "cantino";
    repo = "mcfly";
    rev = "v${version}";
    sha256 = "0fgnhm0b1sd6n12fa2cwlb5b8q4jjm9lqik4lx3l2hv5pkp3dcmb";
  };

  preInstall = ''
    install -Dm644 -t $out/share/mcfly mcfly.bash
    install -Dm644 -t $out/share/mcfly mcfly.zsh
  '';

  cargoSha256 = "11vc4r3cx5amkrmh4hhc174bca02a87i7hfjb33adjvipphfm83f";

  meta = with stdenv.lib; {
    homepage = "https://github.com/cantino/mcfly";
    description = "An upgraded ctrl-r for Bash whose history results make sense for what you're working on right now";
    license = licenses.mit;
    maintainers = [ maintainers.melkor333 ];
  };
}
