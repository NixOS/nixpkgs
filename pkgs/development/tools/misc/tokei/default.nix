{ stdenv, fetchFromGitHub, rustPlatform, libiconv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "tokei";
  version = "10.1.2";

  src = fetchFromGitHub {
    owner = "XAMPPRocky";
    repo = pname;
    rev = "v${version}";
    sha256 = "1h9vk30wdcjkf6wdv1xdiv94ln5ivwhmfhx5kwdvrxx8cci2m3yx";
  };

  cargoSha256 = "11xf2vkhar4y0rb4blq3hk9xlw0ixnig88zzc72hcnkv2yamgkhi";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [
    libiconv darwin.apple_sdk.frameworks.Security
  ];

  # enable all output formats
  cargoBuildFlags = [ "--features" "all" ];

  meta = with stdenv.lib; {
    description = "A program that allows you to count your code, quickly";
    longDescription = ''
      Tokei is a program that displays statistics about your code. Tokei will show number of files, total lines within those files and code, comments, and blanks grouped by language.
    '';
    homepage = https://github.com/XAMPPRocky/tokei;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ gebner lilyball ];
    platforms = platforms.all;
  };
}
