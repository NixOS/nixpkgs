{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "tdns-cli";
  version = "0.0.5";
  
  src = fetchFromGitHub {
    owner = "rotty";
    repo = name;
    rev = "v${version}";
    sha256 = "0nn036in5j1h0vxkwif0lf7fn900zy4f4kxlzy6qdx3jakgmxvwh";
  };

  cargoSha256 = "0v1hx6kjsmydx6ckjqj31y2gcpvax4mshwrniicplkka3q6hx9ra";

  meta = with stdenv.lib; {
    description = "DNS tool that aims to replace dig and nsupdate";
    homepage = "https://github.com/rotty/tdns-cli";
    license = licenses.gpl3;
    maintainers = with maintainers; [ astro ];
  };
}
