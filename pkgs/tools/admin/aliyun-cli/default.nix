{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aliyun-cli";
<<<<<<< HEAD
  version = "3.0.181";
=======
  version = "3.0.161";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "aliyun";
    repo = pname;
    fetchSubmodules = true;
<<<<<<< HEAD
    sha256 = "sha256-xjOoWQyQCVoCDJMXboxFAyil7jRCWU6oIEt7gcPkIPo=";
  };

  vendorHash = "sha256-S8Nthnr3wASvRyZS5UTHILPnUA+FeZJEwIvT0O39U3I=";
=======
    sha256 = "sha256-UYRCVkeNLaTqjcf3cxIXoT+t1ZhDKUsxsbfJzRMaYVI=";
  };

  vendorHash = "sha256-EyaJxlif+jo8N7oi6VCJx/kO+ZR4Mb3od8jJFWbwEoo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "main" ];

  ldflags = [ "-s" "-w" "-X github.com/aliyun/aliyun-cli/cli.Version=${version}" ];

  postInstall = ''
    mv $out/bin/main $out/bin/aliyun
  '';

  meta = with lib; {
    description = "Tool to manage and use Alibaba Cloud resources through a command line interface";
    homepage = "https://github.com/aliyun/aliyun-cli";
    changelog = "https://github.com/aliyun/aliyun-cli/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ornxka ];
    mainProgram = "aliyun";
  };
}
