{ lib, stdenv, fetchFromGitHub, writeText, conf ? null }:

stdenv.mkDerivation rec {
  pname = "abduco";
  version = "2020-04-30";

  src = fetchFromGitHub {
    owner = "martanne";
    repo = "abduco";
    rev = "8c32909a159aaa9484c82b71f05b7a73321eb491";
    sha256 = "0a3p8xljhpk7zh203s75248blfir15smgw5jmszwbmdpy4mqzd53";
  };

  preBuild = lib.optionalString (conf != null)
    "cp ${writeText "config.def.h" conf} config.def.h";

  installFlags = [ "install-completion" ];
  CFLAGS = lib.optionalString stdenv.isDarwin "-D_DARWIN_C_SOURCE";

  meta = with lib; {
    homepage = "http://brain-dump.org/projects/abduco";
    license = licenses.isc;
    description = "Allows programs to be run independently from its controlling terminal";
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.unix;
    mainProgram = "abduco";
  };
}
