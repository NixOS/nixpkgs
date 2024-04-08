{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gci";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "daixiang0";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-02dJ8qiQqUojAlpAQOI/or37nrwgE7phJCMDWr+LI8s=";
  };

  vendorHash = "sha256-7SXTMzc59f9JEyud0UuSkMdqBig5xb4FM5qSamBPMJQ=";

  meta = with lib; {
    description = "Controls golang package import order and makes it always deterministic";
    homepage = "https://github.com/daixiang0/gci";
    license = licenses.bsd3;
    maintainers = with maintainers; [krostar];
  };
}
