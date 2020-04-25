{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gomodifytags";
  version = "1.4.0";

  modSha256 = "0nkdk2zgnwsg9lv20vqk2lshk4g9fqwqxd5bpr78nlahb9xk486s";

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
