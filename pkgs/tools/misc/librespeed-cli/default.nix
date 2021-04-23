{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "librespeed-cli";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "librespeed";
    repo = "speedtest-cli";
    rev = "v${version}";
    sha256 = "03bhxx33fy1cgp83anm51fm8v079v0az0d0p785dz98jg14vzibl";
  };

  vendorSha256 = "1kccxmmzbkzbrxypcrz0j1zz51c0q1d5hh25lcpfbkm3498mj02c";

  # Tests have additonal requirements
  doCheck = false;

  meta = with lib; {
    description = "Command line client for LibreSpeed";
    homepage = "https://github.com/librespeed/speedtest-cli";
    license = with licenses; [ lgpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
