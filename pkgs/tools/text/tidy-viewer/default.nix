{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "tidy-viewer";
<<<<<<< HEAD
  version = "1.5.2";
=======
  version = "1.4.30";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "alexhallam";
    repo = "tv";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-OnvRiQ5H/Vsmfu+F1i68TowjrDwQLQtV1sC6Jrp4xA4=";
  };

  cargoSha256 = "sha256-pIGuBP0a4jWFzkQfqvxQUrBmqYjhERVyEbZvL7g5hRM=";
=======
    sha256 = "sha256-z1H27D0DYQieU91FBZreN6XQCFvwxBJBIWBZRO50cnw=";
  };

  cargoSha256 = "sha256-rLRyzQkwbjIMhLLHSuDKQznBIDV9iAqCUVg6q5gRhsA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # this test parses command line arguments
  # error: Found argument '--test-threads' which wasn't expected, or isn't valid in this context
  checkFlags = [
    "--skip=build_reader_can_create_reader_without_file_specified"
  ];

  meta = with lib; {
    description = "A cross-platform CLI csv pretty printer that uses column styling to maximize viewer enjoyment";
    homepage = "https://github.com/alexhallam/tv";
    changelog = "https://github.com/alexhallam/tv/blob/${version}/CHANGELOG.md";
    license = licenses.unlicense;
    maintainers = with maintainers; [ figsoda ];
  };
}
