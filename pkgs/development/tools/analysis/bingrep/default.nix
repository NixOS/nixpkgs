{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "bingrep";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "m4b";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xig3lrw0jdaxibzirqnm50l8nj4si9pa9w0jypmyhf1lr6yzd0g";
  };

  cargoSha256 = "1fsp1ycfswrzldwnjw5cdwi809fd37pwshvrpf7sp0wmzx2bqhgm";

  meta = with stdenv.lib; {
    description = "Greps through binaries from various OSs and architectures, and colors them";
    homepage = "https://github.com/m4b/bingrep";
    license = licenses.mit;
    maintainers = with maintainers; [ minijackson ];
  };
}
