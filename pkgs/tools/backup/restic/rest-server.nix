{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

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

  patches = [
    (fetchpatch {
      name = "backport_rest-server_tests_os.TempDir.patch";
      url = "https://github.com/restic/rest-server/commit/a87a50ad114bdaddc895413396438df6ea0affbb.patch";
      sha256 = "sha256-O6ENxTK2fCVTZZKTFHrvZ+3dT8TbgbIE0o3sYE/RUqc=";
    })

  ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A high performance HTTP server that implements restic's REST backend API";
    platforms = platforms.unix;
    license = licenses.bsd2;
    maintainers = with maintainers; [ dotlambda ];
  };
}
