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

  modSha256 = "0vhxd3dschj5i9sig6vpxzbl59cas1qa843akzmjnfjrrafb916y";

  meta = with stdenv.lib; {
    homepage = "https://github.com/mozilla/sops";
    description = "Mozilla sops (Secrets OPerationS) is an editor of encrypted files";
    maintainers = [ maintainers.marsam ];
    license = licenses.mpl20;
  };
}
