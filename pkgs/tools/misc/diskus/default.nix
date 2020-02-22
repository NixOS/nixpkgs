{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "diskus";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "diskus";
    rev = "v${version}";
    sha256 = "087w58q5kd3r23a9qnhqgvq4vhv69b5a6a7n3kh09g5cjszy8s05";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "07wsl1vw2aimgmrlri03pfcxv13klqxyvmmsbzgnq9sc9qzzy8gp";

  meta = with stdenv.lib; {
    description = "A minimal, fast alternative to 'du -sh'";
    homepage = https://github.com/sharkdp/diskus;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.fuerbringer ];
    platforms = platforms.unix;
    longDescription = ''
      diskus is a very simple program that computes the total size of the
      current directory. It is a parallelized version of du -sh.
    '';
  };
}
