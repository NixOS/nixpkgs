{ stdenv, pkgs, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  name    = "bat-${version}";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = "bat";
    rev    = "v${version}";
    sha256 = "15d7i0iy5lks3jg9js6n6fy4xanjk76fpryl2kq88kdkq67hpzfp";
  };

  cargoSha256 = "179a7abhzpxjp3cc820jzxg0qk1fiv9rkpazwnzhkjl8yd7b7qi3";

  buildInputs = with pkgs; [ pkgconfig cmake zlib file perl curl ];

  meta = with stdenv.lib; {
    description = "A cat(1) clone with syntax highlighting and Git integration";
    homepage    = https://github.com/sharkdp/bat;
    license     = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir ];
    platforms   = platforms.linux;
  };
}
