{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "MailHog-${version}";
  version = "1.0.0";
  rev = "v${version}";

  goPackagePath = "github.com/mailhog/MailHog";

  src = fetchFromGitHub {
    inherit rev;
    owner = "mailhog";
    repo = "MailHog";
    sha256 = "0r6zidkffb8q12zyxd063jy0ig2x93llna4zb5i2qjh9gb971i83";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Web and API based SMTP testing";
    homepage = "https://github.com/mailhog/MailHog";
    maintainers = with maintainers; [ disassembler ];
    license = licenses.mit;
  };
}
