{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "circleci-cli";
  version = "0.1.16122";

  src = fetchFromGitHub {
    owner = "CircleCI-Public";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zIBEKGp9icdBLwZBMf30d8JxmJwwWrO/arh8ZvMHTSI=";
  };

  vendorSha256 = "sha256-efrjHwHobML/t2lDSFx+UyAOca9dHjZHcAxkFzJqWEo=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X github.com/CircleCI-Public/circleci-cli/version.Version=${version}" "-X github.com/CircleCI-Public/circleci-cli/version.Commit=${src.rev}" "-X github.com/CircleCI-Public/circleci-cli/version.packageManager=nix" ];

  preBuild = ''
    substituteInPlace data/data.go \
      --replace 'packr.New("circleci-cli-box", "../_data")' 'packr.New("circleci-cli-box", "${placeholder "out"}/share/circleci-cli")'
  '';

  postInstall = ''
    install -Dm644 -t $out/share/circleci-cli _data/data.yml
  '';

  meta = with lib; {
    # Box blurb edited from the AUR package circleci-cli
    description = ''
      Command to enable you to reproduce the CircleCI environment locally and
      run jobs as if they were running on the hosted CirleCI application.
    '';
    maintainers = with maintainers; [ synthetica ];
    license = licenses.mit;
    homepage = "https://circleci.com/";
  };
}
