{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "cloud-sql-proxy-${version}";
  version = "1.11";

  goPackagePath = "github.com/GoogleCloudPlatform/cloudsql-proxy";

  subPackages = [ "cmd/cloud_sql_proxy" ];

  src = fetchgit {
    rev = version;
    url = "https://${goPackagePath}";
    sha256 = "13g68i51f03xdh7a1qjmj8j5ljn4drd3n44fn348xfdxqclnx90l";
  };

  goDeps = ./deps.nix;

  buildFlagsArray = [ "-ldflags=" "-X main.versionString=${version}" ];

  meta = with stdenv.lib; {
    description = "An authenticating proxy for Second Generation Google Cloud SQL databases";
    homepage = https://github.com/GoogleCloudPlatform/cloudsql-proxy;
    license = licenses.asl20;
    maintainers = [ maintainers.nicknovitski ];
    platforms = platforms.all;
  };
}
