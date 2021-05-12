{ lib, stdenv
, clarissa
, wget
, cacert
}:

stdenv.mkDerivation rec {

  pname = "clar-oui";
  version = clarissa.version;

  src = clarissa.src;

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "07b9gpjknrgyb0a9fr1sr3mkm3cgr566zjd1jz1iyy2fxb5a3ik5";

  nativeBuildInputs = [ wget cacert ];

  makeFlags = [ "DESTDIR=${placeholder "out"}" "PREFIX=" ];

  dontBuild = true;
  installTargets = [ "clean" "install-oui" ];

  meta = with lib; {
    description = "Organizationally Unique Identifier (OUI) file for use with the clar utility";
    homepage = "https://gitlab.com/evils/clarissa";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.evils ];
  };
}
