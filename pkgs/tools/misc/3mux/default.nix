{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "3mux";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "aaronjanse";
    repo = pname;
    rev = "v${version}";
    sha256 = "164jylifkdfsi3r6vmlp5afgly73fqfbad7lbr58wmy21l9x5rcj";
  };

  vendorSha256 = "0dc1c0z3xkfpwmwb3hafsv7qa6lc7bzz78by5w20rxrrk4r87gic";

  meta = with stdenv.lib; {
    description = "Terminal multiplexer inspired by i3";
    homepage = "https://github.com/aaronjanse/3mux";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjanse filalex77 ];
    # TODO: fix modules build on darwin
    broken = stdenv.isDarwin;
  };
}