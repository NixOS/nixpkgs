{ mkDerivation, lib }:
mkDerivation {
  path = "cddl/share/zfs/compatibility.d";
  extraPaths = [ "sys/contrib/openzfs/cmd/zpool/compatibility.d" ];

<<<<<<< HEAD
  meta = {
    license = lib.licenses.cddl;
=======
  meta = with lib; {
    license = licenses.cddl;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
