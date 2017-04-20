{ stdenv, buildGoPackage, fetchFromGitHub, gcc }:

buildGoPackage rec {
  name = "cockroach-${version}";
  version = "beta-20160929";

  goPackagePath = "github.com/cockroachdb/cockroach";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "cockroachdb";
    repo = "cockroach";
    rev = version;
    sha256 = "1s0sh4avg78inq6m5pws1ddnb69qccff84r92g1d60h6jlb2s8y3";
  };

  buildFlagsArray = ''
    -ldflags=
      -X github.com/cockroachdb/cockroach/build.tag=${version}
  '';

  buildInputs = [ gcc ];

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://www.cockroachlabs.com;
    description = "A scalable, survivable, strongly-consistent SQL database";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.rushmorem ];
  };
}
