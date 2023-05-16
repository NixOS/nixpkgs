{ lib, buildManPages }:

buildManPages {
  pname = "s6-man-pages";
<<<<<<< HEAD
  version = "2.11.3.2.4";
  sha256 = "02dmccmcwssv8bkzs3dlbnwl6kkp1crlbnlv5ljbrgm26klw9rc7";
=======
  version = "2.11.2.0.1";
  sha256 = "LHpQgM+uMDdGYfdaMlhP1bA7Y4UgydUJaDJr7fZlq5Y=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  description = "Port of the documentation for the s6 supervision suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
