{ stdenv, fetchFromGitHub, buildGoPackage, go-bindata, go-bindata-assetfs }:

buildGoPackage rec {
  name = "drone.io-${version}";
  version = "0.5-20160813-${stdenv.lib.strings.substring 0 7 revision}";
  revision = "e82ddd002276deb1741eca5345260ff1c2059abb";
  goPackagePath = "github.com/drone/drone";

  extraSrcs = [ 
    {
      goPackagePath = "github.com/drone/drone-ui";
      src = fetchFromGitHub {
        owner = "drone";
        repo = "drone-ui";
        rev = "43bdae89a59c4d26e24f80f65748b9f78f1df0a9";
        sha256 = "0k0kg07nkk595yk10n1fym3x8wlgn34n3f4mb237gqp8hhlnp5ra";
      };
    }
  ];
  nativeBuildInputs = [ go-bindata go-bindata-assetfs ];

  preBuild = ''
    go generate github.com/drone/drone/server/template
    go generate github.com/drone/drone/store/datastore/ddl
  '';

  src = fetchFromGitHub {
    owner = "drone";
    repo = "drone";
    rev = revision;
    sha256 = "11ld8dzjn4g7wbfm4xqr3ih2dqaqqa8rdnw7m7d3sd78w7r7s3gs";
  };

  meta = with stdenv.lib; {
    maintainer = with maintainers; [ avnik ];
    license = licenses.asl20;
    description = "Continuous Integration platform built on container technology";
  };
}
