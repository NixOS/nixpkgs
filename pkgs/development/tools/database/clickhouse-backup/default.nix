{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "clickhouse-backup";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "AlexAkulov";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1lkG8Rboq6t/hRrdAweo3Kxz9IkukQ39sQSpidFTElw=";
  };

  vendorSha256 = "sha256-N4zAdylb7etNknR0/VjIVkuI6kTWlk137HNT03Y2gWs=";

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
