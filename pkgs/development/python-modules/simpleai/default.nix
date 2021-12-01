{ lib
, buildPythonPackage
, fetchPypi
, numpy
, isPy3k
}:

buildPythonPackage rec {
   version = "0.8.3";
   pname = "simpleai";
   disabled = isPy3k;

   src = fetchPypi {
     inherit pname version;
     sha256 = "1d5be7a00f1f42ed86683019262acbb14e6eca1ed92ce7d7fdf932838d3742e5";
   };

   propagatedBuildInputs = [ numpy ];

   #No tests in archive
   doCheck = false;

   meta = with lib; {
     homepage = "https://github.com/simpleai-team/simpleai";
     description = "This lib implements many of the artificial intelligence algorithms described on the book 'Artificial Intelligence, a Modern Approach'";
     maintainers = with maintainers; [ NikolaMandic ];
   };

}
