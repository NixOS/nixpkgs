{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "3mux";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "aaronjanse";
    repo = pname;
    rev = "v${version}";
    sha256 = "02ry066psvlqdyhimci7nskw4sfb70dw5z7ag7s7rz36gmx1vnmr";
  };

  vendorSha256 = "1hjzpg3q4znvgzk0wbl8rq6cq877xxdsf950bcsks92cs8386847";

  meta = with stdenv.lib; {
    description = "Terminal multiplexer inspired by i3";
    homepage = "https://github.com/aaronjanse/3mux";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjanse filalex77 ];
    # TODO: fix modules build on darwin
    broken = stdenv.isDarwin;
  };
}
