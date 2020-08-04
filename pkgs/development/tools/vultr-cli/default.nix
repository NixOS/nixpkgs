{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vultr-cli";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "vultr";
    repo = pname;
    rev = "v${version}";
    sha256 = "1gqc4w5j9x7vxvxah6hmqd5i1lxyybpml7yfzzcbngwgwm3y5ym0";
  };

  vendorSha256 = null;

  meta = with stdenv.lib; {
    description = "Official command line tool for Vultr services";
    homepage = "https://github.com/vultr/vultr-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 ];
  };
}
