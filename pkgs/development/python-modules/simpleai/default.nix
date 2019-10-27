{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, isPy3k
}:

buildPythonPackage rec {
   version = "0.8.2";
   pname = "simpleai";
   disabled = isPy3k;

   src = fetchPypi {
     inherit pname version;
     sha256 = "2927d460b09ff6dd177999c2f48f3275c84c956efe5b41b567b5316e2259d21e";
   };

   propagatedBuildInputs = [ numpy ];

   #No tests in archive
   doCheck = false;

   meta = with stdenv.lib; {
     homepage = https://github.com/simpleai-team/simpleai;
     description = "This lib implements many of the artificial intelligence algorithms described on the book 'Artificial Intelligence, a Modern Approach'";
     maintainers = with maintainers; [ NikolaMandic ];
   };

}
