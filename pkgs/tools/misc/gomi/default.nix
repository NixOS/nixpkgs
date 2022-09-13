{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gomi";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "b4b4r07";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XXMBEkcZsrr+zYWP4kbIlYDMleZTB2Mygp8mI9UVU1U=";
  };

  vendorSha256 = "sha256-Y5Kn2rJptOCWCrjJd7JfWcfNDfY72bZHrb98NmEhGEc=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Replacement for UNIX rm command";
    homepage = "https://github.com/b4b4r07/gomi";
    license = licenses.mit;
    maintainers = with maintainers; [ ozkutuk ];
  };
}
