{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ligolo-ng";
<<<<<<< HEAD
  version = "0.4.4";
=======
  version = "0.4.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tnpitsecurity";
    repo = "ligolo-ng";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-bv611kvjyXvWVkWpymQn4NLtDAYuXnNi1c3yT3t3p+8=";
  };

  vendorHash = "sha256-MEG1p8PJinFOPIU9+9cxtU9FweCgVMYX8KojQ3ZhKKs=";

=======
    hash = "sha256-O/qiznQs+x7qBYXVItd0W7a0irEzRf0We7kW7HHLqcw=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [ "-s" "-w" "-extldflags '-static'" ];

<<<<<<< HEAD
=======
  vendorHash = "sha256-If0K6DmkGk3AmO3eb/ocAl1RJeBN/xgY7dOh9lnVLh8=";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doCheck = false; # tests require network access

  meta = with lib; {
    homepage = "https://github.com/tnpitsecurity/ligolo-ng";
    description = "A tunneling/pivoting tool that uses a TUN interface";
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ elohmeier ];
  };
}
