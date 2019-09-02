{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  pname = "cloud-sql-proxy";
  version = "1.13";

  goPackagePath = "github.com/GoogleCloudPlatform/cloudsql-proxy";

  subPackages = [ "cmd/cloud_sql_proxy" ];

  src = fetchgit {
    rev = version;
    url = "https://${goPackagePath}";
    sha256 = "07n2hfhqa9hinabmx79aqqwxzzkky76x3jvpd89kch14fijbh532";
  };

  goDeps = ./deps.nix;

  buildFlagsArray = [ "-ldflags=" "-X main.versionString=${version}" ];

  meta = with stdenv.lib; {
    description = "An authenticating proxy for Second Generation Google Cloud SQL databases";
    homepage = "https://${goPackagePath}";
    license = licenses.asl20;
    maintainers = [ maintainers.nicknovitski ];
    platforms = platforms.all;
  };
}
