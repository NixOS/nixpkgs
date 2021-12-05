{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "tidy-viewer";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "alexhallam";
    repo = "tv";
    rev = version;
    sha256 = "sha256-onLu4XNe3sLfZ273Hq9IvgZEV9ir8oEXX7tQG75K2Hw=";
  };

  cargoSha256 = "sha256-CYiRi6ny0wzTddpjdnnMHGqcWRM9wVjF34RmETgLH5A=";

  # this test parses command line arguments
  # error: Found argument '--test-threads' which wasn't expected, or isn't valid in this context
  checkFlags =
    [ "--skip=build_reader_can_create_reader_without_file_specified" ];

  meta = with lib; {
    description =
      "A cross-platform CLI csv pretty printer that uses column styling to maximize viewer enjoyment";
    homepage = "https://github.com/alexhallam/tv";
    changelog = "https://github.com/alexhallam/tv/blob/${version}/CHANGELOG.md";
    license = licenses.unlicense;
    maintainers = with maintainers; [ figsoda ];
  };
}
