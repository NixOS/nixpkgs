{ stdenv, buildPythonPackage, fetchurl, fetchgit, pythonOlder, systemd, pytest }:

buildPythonPackage rec {
  pname = "journalwatch";
  name = "${pname}-${version}";
  version = "1.1.0";
  disabled = pythonOlder "3.3";


  src = fetchurl {
    url = "https://github.com/The-Compiler/${pname}/archive/v${version}.tar.gz";
    sha512 = "3hvbgx95hjfivz9iv0hbhj720wvm32z86vj4a60lji2zdfpbqgr2b428lvg2cpvf71l2xn6ca5v0hzyz57qylgwqzgfrx7hqhl5g38s";
  };

  # can be removed post 1.1.0
  postPatch = ''
    substituteInPlace test_journalwatch.py \
      --replace "U Thu Jan  1 00:00:00 1970 prio foo [1337]" "U Thu Jan  1 00:00:00 1970 pprio foo [1337]"
  '';


  doCheck = true;

  checkPhase = ''
    pytest test_journalwatch.py
  '';

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    systemd
  ];


  meta = with stdenv.lib; {
    description = "journalwatch is a tool to find error messages in the systemd journal.";
    homepage = "https://github.com/The-Compiler/journalwatch";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ florianjacob ];
  };
}
