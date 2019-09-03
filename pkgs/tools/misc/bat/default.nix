{ stdenv, rustPlatform, fetchFromGitHub, llvmPackages, pkgconfig, zlib
, Security, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname   = "bat";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "07qxghplqq8km4kp9zas2acw302a77y72x3ix1272kb1zxhw4as6";
    fetchSubmodules = true;
  };

  cargoSha256 = "0j9wxv21a91yfvbbvgn5ms5zi1aipj1k2g42mfdvvw2vsdzqagxz";

  nativeBuildInputs = [ pkgconfig llvmPackages.libclang zlib ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security libiconv ];

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

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
