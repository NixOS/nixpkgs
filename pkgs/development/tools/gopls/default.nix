{ lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "gopls";
  version = "0.6.10";

  src = fetchgit {
    rev = "gopls/v${version}";
    url = "https://go.googlesource.com/tools";
    sha256 = "13mv6rvqlmgn1shx0hnlqxgqiiiz1ij37j30jz1jkr9kcrbxpacr";
  };

  modRoot = "gopls";
  vendorSha256 = "01apsvkds8f3m88inb37z4lgalrbjp12xr2jikwx7n10hjddgbqi";

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "." ];

  meta = with lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 zimbatm ];
  };
}
