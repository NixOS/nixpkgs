{ lib
, buildNpmPackage
, fetchFromGitHub
, nodePackages
, python3
}:

buildNpmPackage rec {
  pname = "polaris-web";
  version = "build-55";

  src = fetchFromGitHub {
    owner = "agersant";
    repo = "polaris-web";
    rev = version;
    sha256 = "2XqU4sExF7Or7RxpOK2XU9APtBujfPhM/VkOLKVDvF4=";
  };

  npmDepsHash = "sha256-sSd1WSS9xsaVr9mCQueAuqceOv5SkSzqsxX9kHYC8Xo=";

  nativeBuildInputs = [
    nodePackages.node-gyp-build
    python3
  ];

  env.CYPRESS_INSTALL_BINARY = "0";

  # https://github.com/parcel-bundler/parcel/issues/8005
  env.NODE_OPTIONS = "--no-experimental-fetch";

  npmBuildScript = "production";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -a dist $out/share/polaris-web

    runHook postInstall
  '';

  meta = with lib; {
    description = "Web client for Polaris";
    homepage = "https://github.com/agersant/polaris-web";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
