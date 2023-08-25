{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gci";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "daixiang0";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EBklnsZR8VwM89BztligZBDapmgyKuI9Ns8EFFo3ai8=";
  };

  vendorHash = "sha256-g7htGfU6C2rzfu8hAn6SGr0ZRwB8ZzSf9CgHYmdupE8=";

  meta = with lib; {
    description = "Controls golang package import order and makes it always deterministic";
    homepage = "https://github.com/daixiang0/gci";
    license = licenses.bsd3;
    maintainers = with maintainers; [krostar];
  };
}
