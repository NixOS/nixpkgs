{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "tokei-${version}";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "Aaronepower";
    repo = "tokei";
    rev = "v${version}";
    sha256 = "1j8k2i25c989mf15jwy4a4vazjc7x7pm8zywycg8xvv4ik1im7m7";
  };

  depsSha256 = "184x6lwma3lawr2dcc7ivkp1j049af9w040dyzca6i56i2s9998p";

  installPhase = ''
    mkdir -p $out/bin
    cp -p target/release/tokei $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Count code, quickly";
    homepage = https://github.com/Aaronepower/tokei;
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
