{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mysqld_exporter";
<<<<<<< HEAD
  version = "0.15.0";
=======
  version = "0.14.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "mysqld_exporter";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-LW9vH//TjnKbZGMF3owDSUx/Mu0TUuWxMtmdeKM/q7k=";
  };

  vendorHash = "sha256-8zoiYSW8/z1Ch5W1WJHbWAPKFUOhUT8YcjrvyhwI+8w=";
=======
    sha256 = "sha256-SMcpQNygv/jVLNuQP8V6BH/CmSt5Y4dzYPsboTH2dos=";
  };

  vendorSha256 = "sha256-M6u+ZBEUqCd6cKVHPvHqRiXLbuWz66GK+ybIQm+5tQE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = let t = "github.com/prometheus/common/version"; in [
    "-s" "-w"
    "-X ${t}.Version=${version}"
    "-X ${t}.Revision=${src.rev}"
    "-X ${t}.Branch=unknown"
    "-X ${t}.BuildUser=nix@nixpkgs"
    "-X ${t}.BuildDate=unknown"
  ];

  # skips tests with external dependencies, e.g. on mysqld
  preCheck = ''
    buildFlagsArray+="-short"
  '';

  meta = with lib; {
    description = "Prometheus exporter for MySQL server metrics";
    homepage = "https://github.com/prometheus/mysqld_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley globin ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
