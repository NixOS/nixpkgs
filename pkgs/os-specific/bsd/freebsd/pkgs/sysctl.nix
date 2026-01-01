<<<<<<< HEAD
{
  mkDerivation,
  libjail,
}:
mkDerivation {
  path = "sbin/sysctl";
  buildInputs = [
    libjail
  ];
=======
{ mkDerivation, ... }:
mkDerivation {
  path = "sbin/sysctl";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  MK_TESTS = "no";
}
