{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule {
  pname = "demoit";
  version = "unstable-2022-09-03";

  src = fetchFromGitHub {
    owner = "dgageot";
    repo = "demoit";
    rev = "258780987922e46abde8e848247af0a9435e3099";
    sha256 = "sha256-yRfdnqk93GOTBa0zZrm4K3AkUqxGmlrwlKYcD6CtgRg=";
  };
  vendorSha256 = null;
  subPackages = [ "." ];

  meta = with lib; {
    description = "Live coding demos without Context Switching";
    homepage = "https://github.com/dgageot/demoit";
    license = licenses.asl20;
    maintainers = [ maintainers.freezeboy ];
  };
}
