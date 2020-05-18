{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "saml2aws";
  version = "2.25.0";

  src = fetchFromGitHub {
    owner = "Versent";
    repo = "saml2aws";
    rev = "v${version}";
    sha256 = "12aidylamrq4rvy2cfdz669lr1p20yqrshigcc5x1hrlhh9y64xc";
  };

  hid = fetchFromGitHub {
    owner = "karalabe";
    repo = "hid";
    rev = "9c14560f9ee858c43f40b5cd01392b167aacf4e8";
    sha256 = "0xc7b8mwha64j7l2fr2g5zy8pz7cqi0vrxx60gii52b6ii31xncx";
  };

  vendorSha256 = "0mns5clykvj33krf29yjh8lkf05nih42ka5ji7miq0iaikqyyc78";
  overrideModAttrs = (_: {
      postBuild = ''
      cp -r --reflink=auto ${hid}/libusb vendor/github.com/karalabe/hid
      cp -r --reflink=auto ${hid}/hidapi vendor/github.com/karalabe/hid
      '';
    });

  subPackages = [ "." "cmd/saml2aws" ];

  buildFlagsArray = ''
    -ldflags=-X main.Version=${version}
  '';

  meta = with stdenv.lib; {
    description = "CLI tool which enables you to login and retrieve AWS temporary credentials using a SAML IDP";
    homepage    = "https://github.com/Versent/saml2aws";
    license     = licenses.mit;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.pmyjavec ];
  };
}