{ lib, python3Packages, fetchpatch }:

python3Packages.buildPythonApplication rec {
  pname = "pgcli";
  version = "2.0.2";

  # Python 2 won't have prompt_toolkit 2.x.x
  # See: https://github.com/NixOS/nixpkgs/blob/f49e2ad3657dede09dc998a4a98fd5033fb52243/pkgs/top-level/python-packages.nix#L3408
  disabled = python3Packages.isPy27;

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1p4j2dbcfxd3kz86qi519jkqjx1mg5wdgn1gxdjx3lk1vpsd7x04";
  };

  patches = [
    (fetchpatch {
      # TODO: Remove with next pgcli release. Fixes TypeError in tests
      # https://github.com/dbcli/pgcli/pull/1006
      url = https://github.com/dbcli/pgcli/commit/351135b61ef9ad3184c49a406544708daf589fe3.patch;
      sha256 = "08131y0lv1v760i0ypcx2hljx066ks93kp96xkv3bycxnavvcl53";
      excludes = [ "changelog.rst" ];
    })
  ];

  propagatedBuildInputs = with python3Packages; [
    cli-helpers click configobj humanize prompt_toolkit psycopg2
    pygments sqlparse pgspecial setproctitle keyring
  ];

  checkInputs = with python3Packages; [ pytest mock ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Command-line interface for PostgreSQL";
    longDescription = ''
      Rich command-line interface for PostgreSQL with auto-completion and
      syntax highlighting.
    '';
    homepage = https://pgcli.com;
    license = licenses.bsd3;
    maintainers = with maintainers; [ dywedir ];
  };
}
