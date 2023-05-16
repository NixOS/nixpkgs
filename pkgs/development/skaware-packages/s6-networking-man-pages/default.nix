{ lib, buildManPages }:

buildManPages {
  pname = "s6-networking-man-pages";
<<<<<<< HEAD
  version = "2.5.1.3.3";
  sha256 = "02ba5jyfpbib402mfl42pbbdxyjy2vhpiz1b2qdg4ax58yr4jzqk";
=======
  version = "2.5.1.2.1";
  sha256 = "ffTfHqINi0vXGVHbk926U48fxZInrn4AMlSqODOWevo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  description = "Port of the documentation for the s6-networking suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
