{ stdenv
, fetchFromGitHub
, glibc
, cmake
, flex
, bison
, python2
}:

let
  version = "1.1.3";
in stdenv.mkDerivation rec {
  name = "scyther-${version}";

  src = fetchFromGitHub {
    owner = "cascremers";
    repo = "scyther";
    rev = "v${version}";
    sha256 = "0rb4ha5bnjxnwj4f3hciq7kyj96fhw14hqbwl5kr9cdw8q62mx0h";
  };

  preConfigure = ''
    pushd src
    echo "#define TAGVERSION \"${src.rev}\"" >> version.h
    for file in *.*
    do
      substituteInPlace $file --replace "__inline__ " ""
    done
  '';

  postPatch = ''
    patchShebangs src
  '';

  dontUseCmakeBuildDir = true;
  cmakeFlags = [ "-DCMAKE_BUILD_TYPE:STRING=Release" ];

  installPhase = ''
    mkdir -p $out/bin
    cp scyther-linux $out/bin/
  '';

  buildInputs = [
    python2
    glibc.static
    cmake
    flex
    bison
  ];

  meta = with stdenv.lib; {
    description = "Scyther is a tool for the automatic verification of security protocols.";
    homepage = "https://www.cs.ox.ac.uk/people/cas.cremers/scyther/";
    maintainers = with maintainers; [ infinisil ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };

  passthru = {
    inherit version;
  };

}
