{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "sqlboiler-crbd";
  version = "unstable-2022-06-12";

  src = fetchFromGitHub {
    owner = "glerchundi";
    repo = "sqlboiler-crdb";
    rev = "7b35c4d19c05fdc53d1efdcc074f20ee6b56f340";
    hash = "sha256-RlppCRYP7TlM1z1PiXtEVifNVxQHwLuoBXxgYIpUirE=";
  };

  vendorHash = "sha256-N16GH8ZDyeWWBsaaG4RkJwzAbuQ7E8YjZAgVsfeECo4";

  doCheck = false; # requires a running testdb

  meta = with lib; {
    description = "CockroachDB generator for usage with SQLBoiler";
    homepage = "https://github.com/glerchundi/sqlboiler-crdb/";
    maintainers = with maintainers; [ dgollings ];
    platforms = platforms.unix;
  };
}
