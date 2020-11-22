{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dns-over-https";
  version = "2.2.2";
  goPackagePath = "github.com/m13253/dns-over-https";
  subPackages = [ "doh-client" "doh-server" ];
  src = fetchFromGitHub {
    owner = "m13253";
    repo = pname;
    rev = "v${version}";
    sha256 = "12xklf7k07vlqbd7xv9p4c6385h874k8g5sagpcg891lib174bad";
  };
  vendorSha256 = "07jnrhrn45diw7mgscsiwagsdqbh0p69dnwx5bi10v2jrc66zkjd";
  meta = with stdenv.lib; {
    homepage = "https://github.com/m13253/dns-over-https";
    description = "High performance DNS over HTTPS client & server";
    platforms = platforms.unix;
    maintainers = with maintainers; [ dwoffinden ];
    license = licenses.mit;
  };
}
