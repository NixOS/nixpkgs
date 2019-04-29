{ stdenv, fetchFromGitHub, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "sd";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "chmln";
    repo = pname;
    rev = "sd-${version}";
    sha256 = "1y44qizciir75d1srwm1mlskhflab2b6153d19vblw410in82f5d";
  };

  cargoSha256 = "1gls68lw8a2c3gsav70l2wasrgav68q5w1nf50jsrbqq9kb4i7nb";

  meta = with stdenv.lib; {
    description = "Intuitive find & replace CLI (sed alternative)";
    homepage = https://github.com/chmln/sd;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.amar1729 ];
  };
}
