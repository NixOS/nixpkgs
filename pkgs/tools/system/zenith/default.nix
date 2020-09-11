{ stdenv, rustPlatform, fetchFromGitHub, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "zenith";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "bvaisvil";
    repo = pname;
    rev = version;
    sha256 = "04nd5gq49y1k9xxrc9ll155k9j42ivscjzx405qyyxv7dpgyw131";
  };

  cargoSha256 = "0ggpr2skl3d47y771npmbbqb9vga4y4iyry3qn0xj2hg9d7msf4l";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ IOKit ];

  meta = with stdenv.lib; {
    description = "Sort of like top or htop but with zoom-able charts, network, and disk usage";
    homepage = "https://github.com/bvaisvil/zenith";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
    # doesn't build on aarch64 https://github.com/bvaisvil/zenith/issues/19
    platforms = platforms.x86;
  };
}
