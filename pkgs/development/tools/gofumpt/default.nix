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

<<<<<<< HEAD
  vendorHash = "sha256-Il1E1yOejLEdKRRMqelGeJbHRjx4qFymf7N98BEdFzg=";
=======
  vendorSha256 = "sha256-Il1E1yOejLEdKRRMqelGeJbHRjx4qFymf7N98BEdFzg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A stricter gofmt";
    homepage = "https://github.com/mvdan/gofumpt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvolosatovs ];
<<<<<<< HEAD
    mainProgram = "gofumpt";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
