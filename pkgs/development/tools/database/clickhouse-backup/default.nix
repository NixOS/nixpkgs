{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "clickhouse-backup";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "AlexAkulov";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PIn90tz/FnUr4MGKZfLcP0hmF3eqKGB+1gKwfgtk/70=";
  };

  vendorSha256 = "sha256-aPVzXZ7wjVtxjJXhbDlvBhdzoYsvii6OKUaQryrjaNc=";

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  meta = with lib; {
    homepage = "https://github.com/AlexAkulov/clickhouse-backup";
    description = "Tool for easy ClickHouse backup and restore with cloud storages support";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.linux;
  };
}
