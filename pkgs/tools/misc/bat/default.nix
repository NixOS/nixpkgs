{ stdenv, rustPlatform, fetchFromGitHub, cmake, pkgconfig, zlib
, Security, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname   = "bat";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0yyvlplskjvxb2cspqsvfsnahd5m0s83psrp777ng0wc0kr1adbw";
    fetchSubmodules = true;
  };

  cargoSha256 = "078n31c0isvxvna0s1m12xv4bkh15rb2nixfyg4c501mlkalb517";

  nativeBuildInputs = [ cmake pkgconfig zlib ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security libiconv ];

  postInstall = ''
    install -m 444 -Dt $out/share/man/man1 doc/bat.1
    install -m 444 -Dt $out/share/fish/vendor_completions.d assets/completions/bat.fish
  '';

  meta = with stdenv.lib; {
    description = "A cat(1) clone with syntax highlighting and Git integration";
    homepage    = https://github.com/sharkdp/bat;
    license     = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir lilyball ];
    platforms   = platforms.all;
  };
}
