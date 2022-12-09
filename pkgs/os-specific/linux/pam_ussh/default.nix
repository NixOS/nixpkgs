{ buildGoModule
, fetchFromGitHub
, pam
, lib
, nixosTests
}:

buildGoModule rec {
  pname = "pam_ussh";
  version = "unstable-20210615";

  src = fetchFromGitHub {
    owner = "uber";
    repo = "pam-ussh";
    rev = "e9524bda90ba19d3b9eb24f49cb63a6a56a19193";  # HEAD as of 2022-03-13
    sha256 = "0nb9hpqbghgi3zvq41kabydzyc6ffaaw9b4jkc5jrwn1klpw1xk8";
  };

  preBuild = ''
    cp ${./go.mod} go.mod
    cp ${./go.sum} go.sum
  '';

  vendorSha256 = "sha256-fOIzJuTXiDNJak5ilgI2KnPOCogbFWTlPL3yNQdzUUI=";

  buildInputs = [
    pam
  ];

  buildPhase = ''
    runHook preBuild

    if [ -z "$enableParallelBuilding" ]; then
      export NIX_BUILD_CORES=1
    fi
    go build -buildmode=c-shared -o pam_ussh.so -v -p $NIX_BUILD_CORES .

    runHook postBuild
  '';
  checkPhase = ''
    runHook preCheck

    go test -v -p $NIX_BUILD_CORES .

    runHook postCheck
  '';
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/security
    cp pam_ussh.so $out/lib/security

    runHook postInstall
  '';

  passthru.tests = { inherit (nixosTests) pam-ussh; };

  meta = with lib; {
    homepage = "https://github.com/uber/pam-ussh";
    description = "PAM module to authenticate using SSH certificates";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lukegb ];
  };
}
