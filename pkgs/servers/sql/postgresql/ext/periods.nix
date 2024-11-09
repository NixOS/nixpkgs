{ lib, stdenv, fetchFromGitHub, postgresql, buildPostgresqlExtension }:

buildPostgresqlExtension rec {
  pname = "periods";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "xocolatl";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ezt+MtDqPM8OmJCD6oQTS644l+XHZoxuivq0PUIXOY8=";
  };

  meta = with lib; {
    description = "PostgreSQL extension implementing SQL standard functionality for PERIODs and SYSTEM VERSIONING";
    homepage = "https://github.com/xocolatl/periods";
    maintainers = with maintainers; [ ivan ];
    platforms = postgresql.meta.platforms;
    license = licenses.postgresql;
  };
}
