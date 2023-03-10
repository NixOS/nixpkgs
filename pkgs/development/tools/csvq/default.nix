{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "csvq";
  version = "1.17.11";

  src = fetchFromGitHub {
    owner = "mithrandie";
    repo = "csvq";
    rev = "v${version}";
    sha256 = "sha256-jhj03xpWBcLVCCk1S9nsi8O6x1/IVwNT3voGfWBg2iw=";
  };

  vendorSha256 = "sha256-C+KQHSp4aho+DPlkaYegjYSaoSHaLiQOa1WJXIn9FdQ=";

  meta = with lib; {
    description = "SQL-like query language for CSV";
    homepage = "https://mithrandie.github.io/csvq/";
    changelog = "https://github.com/mithrandie/csvq/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ tomodachi94 ];
  };
}
