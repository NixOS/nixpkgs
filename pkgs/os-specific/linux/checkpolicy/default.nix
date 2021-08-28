{ lib, stdenv, fetchurl, bison, flex, libsepol }:

stdenv.mkDerivation rec {
  pname = "checkpolicy";
  version = "2.9";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/checkpolicy-${version}.tar.gz";
    sha256 = "13jz6f8zdrijvn5w1j102b36fs41z0q8ii74axw48cj550mw6im9";
  };

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ libsepol ];

  makeFlags = [
    "PREFIX=$(out)"
    "LIBSEPOLA=${lib.getLib libsepol}/lib/libsepol.a"
  ];

  meta = removeAttrs libsepol.meta ["outputsToInstall"] // {
    description = "SELinux policy compiler";
  };
}
