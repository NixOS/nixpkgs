{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "tere";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "mgunyho";
    repo = "tere";
    rev = "v${version}";
    sha256 = "sha256-2DpJYOzswT7dHEIj+qaTx1Jm28NE+61opoxuMChNwbM=";
  };

  cargoSha256 = "sha256-8qSikfsHX8xwBqSSxWwNbiOpXmfzwGTAOALPjxVHadc=";

  # This test confirmed not working.
  # https://github.com/mgunyho/tere/issues/44
  cargoPatches = [ ./brokentest.patch ];

  meta = with lib; {
    description = "A faster alternative to cd + ls";
    homepage = "https://github.com/mgunyho/tere";
    license = licenses.eupl12;
    maintainers = with maintainers; [ ProducerMatt ];
  };
}
