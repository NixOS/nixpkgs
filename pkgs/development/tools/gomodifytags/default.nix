{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gomodifytags";
  version = "1.4.0";

  vendorSha256 = null;

  goPackagePath = "github.com/fatih/gomodifytags";

  src = fetchFromGitHub {
    owner = "fatih";
    repo = "gomodifytags";
    rev = "v${version}";
    sha256 = "1436wjqs6n2jxlyzx38nm4ih6fr11bybivg3wy5nvzfs6cs59q63";
  };

  meta = {
    description = "Go tool to modify struct field tags.";
    homepage = "https://github.com/fatih/gomodifytags";
    maintainers = with stdenv.lib.maintainers; [ vdemeester ];
    license = stdenv.lib.licenses.bsd3;
  };
}