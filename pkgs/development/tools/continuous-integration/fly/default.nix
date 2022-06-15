{ buildGoModule, fetchFromGitHub, stdenv, lib, installShellFiles }:

buildGoModule rec {
  pname = "fly";
  version = "7.8.0";

  src = fetchFromGitHub {
    owner = "concourse";
    repo = "concourse";
    rev = "v${version}";
    sha256 = "sha256-CYQQ44Yx97PvhFHrTzUM2RooNCh5Sdg8SXsV4BOzzPE=";
  };

  vendorSha256 = "sha256-aYu5K6pK6Q0Fmagr91i6nc3t55nUjn5vasIO+kUXWrs=";

  subPackages = [ "fly" ];

  ldflags = [
    "-s" "-w" "-X github.com/concourse/concourse.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  postInstall = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    installShellCompletion --cmd fly \
      --bash <($out/bin/fly completion --shell bash) \
      --fish <($out/bin/fly completion --shell fish) \
      --zsh <($out/bin/fly completion --shell zsh)
  '';

  meta = with lib; {
    description = "Command line interface to Concourse CI";
    homepage = "https://concourse-ci.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ ivanbrennan SuperSandro2000 ];
  };
}
