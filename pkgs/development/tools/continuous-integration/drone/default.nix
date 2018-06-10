{ stdenv, fetchFromGitHub, buildGoPackage, go-bindata, go-bindata-assetfs }:

buildGoPackage rec {
  name = "drone.io-${version}";
  version = "0.8.5-20180329-${stdenv.lib.strings.substring 0 7 revision}";
  revision = "81103a98208b0bfc76be5b07194f359fbc80183b";
  goPackagePath = "github.com/drone/drone";

  # These dependencies pulled (in `drone` buildprocess) via Makefile,
  # so I extracted them here, all revisions pinned by same date, as ${version}
  goDeps= ./deps.nix;

  nativeBuildInputs = [ go-bindata go-bindata-assetfs ];

  src = fetchFromGitHub {
    owner = "drone";
    repo = "drone";
    rev = revision;
    sha256 = "1890bwhxr62adv261v4kn1azhq7qvcj2zpll68i9nsvjib8a52bq";
  };

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ avnik vdemeester ];
    license = licenses.asl20;
    description = "Continuous Integration platform built on container technology";
  };
}
