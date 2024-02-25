{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gci";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "daixiang0";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rR3aTNVKg5uUJ39SEEySHkwGotrfzHjC9KL3FDf1jik=";
  };

  vendorHash = "sha256-bPRcOvwbWEpcJUlIqQNeoYME4ky0YE5LlyWhSTWCIHQ=";

  meta = with lib; {
    description = "Controls golang package import order and makes it always deterministic";
    homepage = "https://github.com/daixiang0/gci";
    license = licenses.bsd3;
    maintainers = with maintainers; [krostar];
  };
}
