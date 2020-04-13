{ stdenv, buildGoModule, fetchFromGitHub, brotli, Security }:

buildGoModule rec {
  pname = "wal-g";
  version = "0.2.15";

  src = fetchFromGitHub {
    owner = "wal-g";
    repo = "wal-g";
    rev = "v${version}";
    sha256 = "1hslhs9i4wib6c74gdq9yail958ff1y11pymjww2xr84wkwd9v7i";
  };

  modSha256 = "0kwl5gwc5gc0cq2gldg13nvswp9wd90xiv1qb3g8yxcczywkpmrm";

  buildInputs = [ brotli ] ++ stdenv.lib.optionals stdenv.isDarwin [ Security ];

  doCheck = true;

  subPackages = [ "main/pg" ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/wal-g/wal-g/cmd/pg.WalgVersion=${version} -X github.com/wal-g/wal-g/cmd/pg.GitRevision=${src.rev}" ];

  postInstall = ''
    mv $out/bin/pg $out/bin/wal-g
  '';

  meta = {
    homepage = "https://github.com/wal-g/wal-g";
    license = stdenv.lib.licenses.asl20;
    description = "An archival restoration tool for PostgreSQL";
    maintainers = [ stdenv.lib.maintainers.ocharles ];
  };
}
