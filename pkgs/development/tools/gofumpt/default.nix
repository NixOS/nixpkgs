{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gofumpt";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uXRYVLFDyRZ83mth8Fh+MG9fNv2lUfE3BTljM9v9rjI=";
  };

  vendorSha256 = "sha256-Il1E1yOejLEdKRRMqelGeJbHRjx4qFymf7N98BEdFzg=";

  meta = with lib; {
    description = "A stricter gofmt";
    homepage = "https://github.com/mvdan/gofumpt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
