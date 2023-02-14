{ lib, fetchgit, stdenv, autoreconfHook269, gnumake, libtool, attr }:

stdenv.mkDerivation rec {
  pname = "nfs4-acl-tools";
  version = "0.3.7";

  src = fetchgit {
    url = "git://git.linux-nfs.org/projects/bfields/nfs4-acl-tools.git";
    rev = "${pname}-${version}";
    sha256 = "McDRqKSFMy2iDUJReqRNr+4uSEd6o5D0e9r3qVXrCVM=";
  };

  nativeBuildInputs = [ autoreconfHook269 ];
  MAKE = "${gnumake}/bin/make";
  LIBTOOL = "${libtool}/bin/libtool";

  buildInputs = [ attr.dev ];

  meta = with lib; {
    description = "Linux NFSv4 ACL tools (provides nfs4_getfacl, nfs4_setfacl and nfs4_editfacl)";

    # University of Michigan license
    # http://git.linux-nfs.org/?p=bfields/nfs4-acl-tools.git;a=blob_plain;f=COPYING;hb=HEAD
    # I couldn't find a canonical URL to add it the Nixpkgs list of licenses

    homepage = "http://git.linux-nfs.org/?p=bfields/nfs4-acl-tools.git;a=summary";
    maintainers =  with maintainers; [ danth ];
    platforms = platforms.unix;
  };
}
