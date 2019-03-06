{ stdenv, fetchurl, bison, flex, libsepol }:

stdenv.mkDerivation rec {
  name = "checkpolicy-${version}";
  version = "2.8";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/checkpolicy-${version}.tar.gz";
    sha256 = "1j4lh44nikxahkrbiz5265ar9fqxrzm6a4vlpz1mi3mq4hf83v4x";
  };

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ libsepol ];

  makeFlags = [
    "PREFIX=$(out)"
    "LIBSEPOLA=${stdenv.lib.getLib libsepol}/lib/libsepol.a"
  ];

  meta = removeAttrs libsepol.meta ["outputsToInstall"] // {
    description = "SELinux policy compiler";
  };
}
