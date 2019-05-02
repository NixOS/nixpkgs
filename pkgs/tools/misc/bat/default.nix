{ stdenv, rustPlatform, fetchFromGitHub, cmake, pkgconfig, zlib
, Security, libiconv
}:

rustPlatform.buildRustPackage rec {
  name    = "bat-${version}";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = "bat";
    rev    = "v${version}";
    sha256 = "1q22lbyrwh58vhznpjpkiaa8v4qv6a3a8lrxzaypd8wg78p9dca6";
    fetchSubmodules = true;
  };

  cargoSha256 = "0npj2rf4vr45gq3qwqq6kqnv9dh58v5lpx0gsmy2qrq44dxb75rq";

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
