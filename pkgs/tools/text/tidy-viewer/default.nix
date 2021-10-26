{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "tidy-viewer";
  version = "0.0.22";

  src = fetchFromGitHub {
    owner = "alexhallam";
    repo = "tv";
    rev = version;
    sha256 = "sha256-OuNpp9EKiU+fQSZZO7zpI36nCiZBXK6OznJGY4KMftU=";
  };

  cargoSha256 = "sha256-LRoNGDOrbCjmZJRe+EUKxkDJjC92bQRRwP48jqDp9PU=";

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
