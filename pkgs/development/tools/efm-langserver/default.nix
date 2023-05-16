{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "efm-langserver";
<<<<<<< HEAD
  version = "0.0.48";
=======
  version = "0.0.44";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "efm-langserver";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-do/p4sQ/OoswiC/19gKk5xeWbZ8iEOX5oPg5cY7ofYA=";
  };

  vendorHash = "sha256-+QYJijb5l++fX7W4xVtAZyQwjEsGEuStFAUHPB4cVHE=";
=======
    sha256 = "sha256-+yN08MAoFaixvt2EexhRNucG6I4v2FdHf44XlYIwzhA=";
  };

  vendorSha256 = "sha256-KABezphT5/o3XWSFNe2OvfawFR8uwsGMnjsI9xh378Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  subPackages = [ "." ];

  meta = with lib; {
    description = "General purpose Language Server";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/mattn/efm-langserver";
    license = licenses.mit;
  };
}
