<<<<<<< HEAD
{ lib, python3Packages, fetchPypi, patatt }:

python3Packages.buildPythonApplication rec {
  pname = "b4";
  version = "0.12.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tk4VBvSnHE6VnUAa3QYCqFLQbsHTJ6Bfqwa1wKEC6mI=";
=======
{ lib, python3Packages, patatt }:

python3Packages.buildPythonApplication rec {
  pname = "b4";
  version = "0.12.2";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "tvSv14v3iigFWzifCQl5Kxx4Bfs1V/XXHvvaNoKqvm4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # tests make dns requests and fails
  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
    requests
    dnspython
    dkimpy
    patatt
    git-filter-repo
  ];

  meta = with lib; {
    homepage = "https://git.kernel.org/pub/scm/utils/b4/b4.git/about";
    license = licenses.gpl2Only;
    description = "A helper utility to work with patches made available via a public-inbox archive";
<<<<<<< HEAD
    mainProgram = "b4";
    maintainers = with maintainers; [ jb55 qyliss mfrw ];
=======
    maintainers = with maintainers; [ jb55 qyliss ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
