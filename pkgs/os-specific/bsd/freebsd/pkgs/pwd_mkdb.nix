{ mkDerivation, ... }:
mkDerivation {
  path = "usr.sbin/pwd_mkdb";

  extraPaths = [ "lib/libc/gen" ];
<<<<<<< HEAD

  meta.mainProgram = "pwd_mkdb";
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}
