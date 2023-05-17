{ lib
, buildGoModule
, fetchFromGitHub
, clickhouse-23_3_x
, goflow2-1_x
, goose
}:

buildGoModule {
  pname = "netmeta";
  version = "unstable-2023-10-26";

  src = fetchFromGitHub {
    owner = "monogon-dev";
    repo = "NetMeta";
    rev = "300481fd168e023f76ca37db219eeeaa92960883";
    hash = "sha256-NojxziLuUuYdlbqAA7yqmNVczPANENnXnckOMv+EqnU=";
  };

  subPackages = [
    "cmd/portmirror"
    "cmd/reconciler"
    "cmd/risinfo"
  ];

  vendorHash = "sha256-sgv3WhtqMcZoUYmBBBKhgNtpRYdW9dMWbB+4L3Gyv5E=";

  passthru = {
    clickhouse = clickhouse-23_3_x;
    goflow2 = goflow2-1_x;
    goose = goose;
  };

  meta = with lib; {
    description = "A scalable network observability toolkit optimized for performance";
    homepage = "https://github.com/monogon-dev/NetMeta";
    license = licenses.asl20;
    maintainers = teams.wdz.members;
  };
}

