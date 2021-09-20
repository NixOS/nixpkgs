{ buildGoModule, common-updater-scripts, fetchFromGitHub, genericUpdater, lib }:

buildGoModule rec {
  pname = "go-swag";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "swaggo";
    repo = "swag";
    rev = "v${version}";
    sha256 = "1hcpq85rdip2q75zxqdx2nbn9v1m89vliyc7gbir4f8nw4dzvcwm";
  };

  vendorSha256 = "0n6f4z2jvmpg7pr3pyq64a4rh150ixn8dwkzk17j0vcy4bh9fka3";

  subPackages = [ "cmd/swag" ];

   passthru = {
     updateScript = genericUpdater {
       inherit pname version;
       versionLister = "${common-updater-scripts}/bin/list-git-tags ${src.meta.homepage}";
       rev-prefix = "v";
       ignoredVersions = ".(rc|beta).*";
     };
   };

  meta = with lib; {
    description = "Automatically generate RESTful API documentation with Swagger 2.0 for Go";
    homepage = "https://github.com/swaggo/swag";
    license = licenses.mit;
    maintainers = with maintainers; [ stephenwithph ];
  };
}
