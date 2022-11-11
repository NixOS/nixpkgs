{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vale";
  version = "2.21.0";

  subPackages = [ "cmd/vale" ];
  outputs = [ "out" "data" ];

  src = fetchFromGitHub {
    owner = "errata-ai";
    repo = "vale";
    rev = "v${version}";
    sha256 = "sha256-H+Hi9KS8gDAfXNqotHdkzWK1m8twOajC8kf/uLUEAv4=";
  };

  vendorSha256 = "sha256-ODzQkNOXEvSOhG6MoJbyxIwduFAW5FQb5hlOn3+io3A=";

  postInstall = ''
    mkdir -p $data/share/vale
    cp -r testdata/styles $data/share/vale
  '';

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    homepage = "https://vale.sh/";
    description = "A syntax-aware linter for prose built with speed and extensibility in mind";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
