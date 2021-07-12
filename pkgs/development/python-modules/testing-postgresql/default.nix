{ lib, buildPythonPackage, fetchFromGitHub, postgresql, testing-common-database
, pg8000, pytestCheckHook, psycopg2, sqlalchemy }:

buildPythonPackage rec {
  pname = "testing.postgresql";
  # Version 1.3.0 isn't working so let's use the latest commit from GitHub
  version = "unstable-2017-10-31";

  src = fetchFromGitHub {
    owner = "tk0miya";
    repo = pname;
    rev = "c81ded434d00ec8424de0f9e1f4063c778c6aaa8";
    sha256 = "1asqsi38di768i1sc1qm1k068dj0906ds6lnx7xcbxws0s25m2q3";
  };

  # Add PostgreSQL to search path
  prePatch = ''
    substituteInPlace src/testing/postgresql.py \
      --replace "/usr/local/pgsql" "${postgresql}"
  '';

  propagatedBuildInputs = [ testing-common-database pg8000 ];

  # Fix tests for Darwin build. See:
  # https://github.com/NixOS/nixpkgs/pull/74716#issuecomment-598546916
  __darwinAllowLocalNetworking = true;

  checkInputs = [ pytestCheckHook psycopg2 sqlalchemy ];

  meta = with lib; {
    description = "Use temporary postgresql instance in testing";
    homepage = "https://github.com/tk0miya/testing.postgresql";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
