{ stdenv
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  version = "0.1.2";
  pname = "vultr";

  src = fetchFromGitHub {
      owner = "spry-group";
      repo = "python-vultr";
      rev = "${version}";
      sha256 = "1qjvvr2v9gfnwskdl0ayazpcmiyw9zlgnijnhgq9mcri5gq9jw5h";
  };

  propagatedBuildInputs = [ requests ];

  # Tests disabled. They fail because they try to access the network
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Vultr.com API Client";
    homepage = "https://github.com/spry-group/python-vultr";
    license = licenses.mit;
    maintainers = with maintainers; [ lihop ];
  };

}
