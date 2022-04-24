{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "restic-rest-server";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "restic";
    repo = "rest-server";
    rev = "v${version}";
    hash = "sha256-ninPODztNzvB2js9cuNAuExQLK/OGOu80ZNW0BPrdds=";
  };

  vendorSha256 = "sha256-8x5qYvIX/C5BaewrTNVbIIadL+7XegbRUZiEDWmJM+c=";

  preCheck = ''
    substituteInPlace cmd/rest-server/main_test.go \
      --replace "/tmp/restic" "/build/restic"
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A high performance HTTP server that implements restic's REST backend API";
    platforms = platforms.unix;
    license = licenses.bsd2;
    maintainers = with maintainers; [ dotlambda ];
  };
}
