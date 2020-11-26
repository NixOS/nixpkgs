{ lib, buildGoModule, fetchFromGitHub, go-bindata, go-bindata-assetfs, nixosTests }:

buildGoModule rec {
  pname = "documize-community";
  version = "3.8.1";

  src = fetchFromGitHub {
    owner = "documize";
    repo = "community";
    rev = "30d12ba756101a3d360e874cc8fad2a53ec558ed";
    sha256 = "sha256-URQtOXwMavPD9/9n2YO1Z9Rg/i26gYb53OC8WEpbelk=";
  };

  vendorSha256 = null;

  doCheck = false;

  nativeBuildInputs = [ go-bindata go-bindata-assetfs ];

  # This is really weird, but they've managed to screw up
  # their folder structure enough, you can only build by
  # literally cding into this folder.
  preBuild = "cd edition";

  subPackages = [ "." ];

  passthru.tests = { inherit (nixosTests) documize; };

  postInstall = ''
    mv $out/bin/edition $out/bin/documize
  '';

  meta = with lib; {
    description = "Open source Confluence alternative for internal & external docs built with Golang + EmberJS";
    license = licenses.agpl3;
    maintainers = with maintainers; [ ma27 elseym ];
    homepage = "https://www.documize.com/";
  };
}
