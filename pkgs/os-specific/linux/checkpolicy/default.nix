{ lib, stdenv, fetchurl, bison, flex, libsepol }:

stdenv.mkDerivation rec {
  pname = "checkpolicy";
  version = "3.5";
  inherit (libsepol) se_url;

  src = fetchurl {
    url = "${se_url}/${version}/checkpolicy-${version}.tar.gz";
    sha256 = "sha256-eqSKsiIqC5iBER1tf3DDAU09kziCfZ4C3xBaaMDfXbw=";
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
