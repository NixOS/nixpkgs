{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "1a28kkxcrdfmrq2mmsfkdxfp3msklwga5nbfhjb7a7s64xh8jmjv";
  };

  cargoSha256 = "1xlxjr0pkwlzm7f5xlrsf76in28r9jj41n6gn44vxqbh4x161gs1";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    license = licenses.mit;
    maintainers = with maintainers; [ dalance filalex77 ];
    platforms = with platforms; linux ++ darwin;
  };
}
