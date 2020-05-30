{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sops";
  version = "3.5.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "mozilla";
    repo = pname;
    sha256 = "1515bk0fl0pvdkp402l51gdg63bmqlh89sglss6prc1qqvv5v2xy";
  };

  vendorSha256 = "0yryc799k4563wy53z7amraj89cyprklj0lfv207530hwv5i5gm6";

  meta = with stdenv.lib; {
    homepage = "https://github.com/mozilla/sops";
    description = "Mozilla sops (Secrets OPerationS) is an editor of encrypted files";
    maintainers = [ maintainers.marsam ];
    license = licenses.mpl20;
  };
}