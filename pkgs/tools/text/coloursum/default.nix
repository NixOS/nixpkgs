{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "coloursum-${version}";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "ticky";
    repo = "coloursum";
    rev = "v${version}";
    sha256 = "18ikwi0ihn0vadazrkh85jfz8a2f0dkfb3zns5jzh7p7mb0ylrr2";
  };

  cargoSha256 = "0f73vqa82w4ccr0cc95mxga3r8jgd92jnksshxzaffbpx4s334p3";

  meta = with stdenv.lib; {
    description = "Colourise your checksum output";
    homepage = "https://github.com/ticky/coloursum";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ fgaz ];
  };
}
