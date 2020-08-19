{ lib
, buildGoModule
, fetchFromGitHub
, sqlite-replication
, dqlite
, raft-canonical
, libco-canonical
}:
buildGoModule rec {
  pname = "go-dqlite";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "go-dqlite";
    rev = "v${version}";
    sha256 = "17b0by6vxz7dyrbx7wrrrjn4nd2vlcsdzxwrjkgjzqihgbcx5f75";
  };

  buildInputs = [
    dqlite.dev
    libco-canonical.dev
    raft-canonical.dev
    sqlite-replication
  ];

  buildFlags = [ "-tags libsqlite3" ];

  doCheck = false;

  vendorSha256 = "1j3q52w39bi66al62hcd04rwi86n1p96116vqpwcaw14gvkd9ihb";

  meta = with lib; {
    description = "A pure-Go client for the dqlite wire protocol";
    homepage = "https://github.com/canonical/go-dqlite";
    license = licenses.asl20;
    maintainers = with maintainers; [ mt-caret ];
    platforms = platforms.linux;
  };
}
