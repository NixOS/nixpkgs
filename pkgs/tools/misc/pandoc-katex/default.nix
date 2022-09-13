{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "pandoc-katex";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "xu-cheng";
    repo = pname;
    rev = version;
    hash = "sha256-Sd+f1a3Y4XwSj5BupAH35UK6gQxzLy5jJCtc77R9wnM=";
  };

  cargoSha256 = "sha256-PVEQTzkkD6V9DqcIHznfnO1wOARSxutLApaO9dlokTQ=";

  meta = with lib; {
    description = "Pandoc filter to render math equations using KaTeX";
    homepage = "https://github.com/xu-cheng/pandoc-katex";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ minijackson pacien ];
  };
}
