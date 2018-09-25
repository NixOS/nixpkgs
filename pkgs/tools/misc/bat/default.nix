{ stdenv, rustPlatform, fetchFromGitHub, cmake, pkgconfig, zlib
, Security, libiconv
}:

rustPlatform.buildRustPackage rec {
  name    = "bat-${version}";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = "bat";
    rev    = "v${version}";
    sha256 = "1fzk0z7r70rjvv2c6531zaa1jzbcb7j9wbi0xqb9y4dls538bmz0";
    fetchSubmodules = true;
  };

  cargoSha256 = "19syz0sxcpk3i4675bfq5gpb9i6hp81in36w820kkvamaimq10nd";

  nativeBuildInputs = [ cmake pkgconfig zlib ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security libiconv ];

  postInstall = ''
    install -m 444 -Dt $out/share/man/man1 doc/bat.1
  '';

  meta = with stdenv.lib; {
    description = "A cat(1) clone with syntax highlighting and Git integration";
    homepage    = https://github.com/sharkdp/bat;
    license     = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir ];
    platforms   = platforms.linux ++ platforms.darwin;
  };
}
