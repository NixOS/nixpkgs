{ lib
, stdenv
, fetchFromGitHub
, bzip2
, libdivsufsort
, jsoncpp
, openssl
, mpfr
}:

stdenv.mkDerivation rec {
  pname = "SP800-90B_EntropyAssessment";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "SP800-90B_EntropyAssessment";
    rev = "v${version}";
    hash = "sha256-KZQ7kC0PbBkjLEQZIqYakQ91OvCxruhdfUwiRHtno3w=";
  };

  buildInputs = [ bzip2 libdivsufsort jsoncpp openssl mpfr ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "-march=native" ""
  '';

  sourceRoot = "${src.name}/cpp";

  makeFlags = [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    "ARCH=${stdenv.hostPlatform.linuxArch}"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp ea_* $out/bin
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/usnistgov/SP800-90B_EntropyAssessment";
    description = "Implementation of min-entropy assessment methods included in Special Publication 800-90B";
    platforms = lib.platforms.linux;
    license = lib.licenses.nistSoftware;
    maintainers = with lib.maintainers; [ orichter thillux ];
  };
}
