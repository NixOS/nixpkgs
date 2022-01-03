{ lib
, fetchFromGitHub
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "seafobj";
  version = "unstable-2021-07-08";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafobj";
    rev = "df13a98e7e32c926083ca60bb7fb1bbc4dfcdbd0";
    sha256 = "0jwgbx083mwwh18x7450igq748bbld9s7zgibwv1cxwrrny1aari";
  };

  patches = [
    ./setuptools.patch
  ];

  doCheck = false; # disabled because it requires a ccnet environment

  meta = with lib; {
    homepage = "https://github.com/haiwen/seafobj";
    description = "Python library for accessing seafile data model";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pacman99 ];
  };
}
