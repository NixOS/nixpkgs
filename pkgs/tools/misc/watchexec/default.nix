{ stdenv, rustPlatform, fetchFromGitHub }:

with rustPlatform;

buildRustPackage rec {
  name = "watchexec-${version}";
  version = "1.8.6";

  src = fetchFromGitHub {
    owner = "mattgreen";
    repo = "watchexec";
    rev = "${version}";
    sha256 = "1jib51dbr6s1iq21inm2xfsjnz1730nyd3af1x977iqivmwdisax";
  };

  cargoSha256 = "0sm1jvx1y18h7y66ilphsqmkbdxc76xly8y7kxmqwdi4lw54i9vl";

  meta = with stdenv.lib; {
    description = "Executes commands in response to file modifications";
    homepage = https://github.com/mattgreen/watchexec;
    license = with licenses; [ asl20 ];
    maintainers = [ maintainers.michalrus ];
    platforms = [ "x86_64-linux" ];
  };
}
