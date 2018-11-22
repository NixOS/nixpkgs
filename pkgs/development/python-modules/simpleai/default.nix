{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, isPy3k
}:

buildPythonPackage rec {
   version = "0.7.11";
   pname = "simpleai";
   disabled = isPy3k;

   src = fetchPypi {
     inherit pname version;
     sha256 = "03frjc5jxsz9xm24jz7qa4hcp0dicgazrxkdsa2rsnir672lwkwz";
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
