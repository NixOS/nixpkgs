{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  name = "watchexec-${version}";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "watchexec";
    repo = "watchexec";
    rev = version;
    sha256 = "0zp5s2dy5zbar0virvy1izjpvvgwbz7rvjmcy6bph6rb5c4bhm70";
  };

  cargoSha256 = "1li84kq9myaw0zwx69y72f3lx01s7i9p8yays4rwvl1ymr614y1l";

  meta = with stdenv.lib; {
    description = "Executes commands in response to file modifications";
    homepage = https://github.com/watchexec/watchexec;
    license = with licenses; [ asl20 ];
    maintainers = [ maintainers.michalrus ];
    platforms = platforms.linux;
  };
}
