{ lib, buildGoModule, fetchFromGitHub, coreutils }:

buildGoModule rec {
  pname = "skeema";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "skeema";
    repo = "skeema";
    rev = "v${version}";
    sha256 = "sha256-PyQ5nLoJl3N/ewmHTZZHRLj9WV3EsUjL6fyESc8POss=";
  };

  vendorSha256 = null;

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" ];

  preCheck = ''
    # Disable tests requiring network access to gitlab.com
    buildFlagsArray+=("-run" "[^(Test(ParseDir(Symlinks|))|DirRelPath)]")

    # Fix tests expecting /usr/bin/printf and /bin/echo
    substituteInPlace skeema_cmd_test.go \
      --replace /usr/bin/printf "${coreutils}/bin/printf"

    substituteInPlace internal/fs/dir_test.go \
      --replace /bin/echo "${coreutils}/bin/echo" \
      --replace /usr/bin/printf "${coreutils}/bin/printf"

    substituteInPlace internal/applier/ddlstatement_test.go \
      --replace /bin/echo "${coreutils}/bin/echo"

    substituteInPlace internal/util/shellout_unix_test.go \
      --replace /bin/echo "${coreutils}/bin/echo" \
      --replace /usr/bin/printf "${coreutils}/bin/printf"

    substituteInPlace internal/util/shellout_unix_test.go \
      --replace /bin/echo "${coreutils}/bin/echo"
  '';

  meta = with lib; {
    description = "Declarative pure-SQL schema management for MySQL and MariaDB";
    homepage = "https://skeema.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
