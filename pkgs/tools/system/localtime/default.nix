{ buildGoModule
, fetchFromGitHub
, lib
, m4
}:

buildGoModule {
  pname = "localtime";
  version = "unstable-2022-02-20";

  src = fetchFromGitHub {
    owner = "Stebalien";
    repo = "localtime";
    rev = "c1e10aa4141ed2bb01986b48e0e942e618993c06";
    hash = "sha256-bPQ1c2KUTkxx2g7IvLmrKgJKfRHTLlTXLR/QQ0O4CrI=";
  };

  vendorSha256 = "sha256-12JnEU41sp9qRP07p502EYogveE+aNdfmLwlDRbIdxU=";

  nativeBuildInputs = [ m4 ];

  buildPhase = ''
    runHook preBuild
    make PREFIX="$out"
    runHook postBuild
  '';

  doCheck = false; # no tests

  installPhase = ''
    runHook preInstall
    make PREFIX="$out" install
    runHook postInstall
  '';

  meta = with lib; {
    description = "A daemon for keeping the system timezone up-to-date based on the current location";
    homepage = "https://github.com/Stebalien/localtime";
    maintainers = with maintainers; [ lovesegfault ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
