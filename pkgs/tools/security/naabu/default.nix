{ lib
, buildGoModule
, fetchFromGitHub
, libpcap
}:

buildGoModule rec {
  pname = "naabu";
<<<<<<< HEAD
  version = "2.1.7";
=======
  version = "2.1.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "naabu";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-x6TmV8c5p9Uuc9uJG3+FNNpdmzdzgQpsyO29dly7PuU=";
  };

  vendorHash = "sha256-9LIPRiLKszfz9Gj26G03TPHOqCXi1s3CYiaadInlD84=";
=======
    hash = "sha256-STykmBsKLcuPhNrk/RHwvlkz9L+IwiALY7Iuvuu3dPM=";
  };

  vendorHash = "sha256-yY5zVlZolc8NLiySBOwKIIa+UN/hsqe9/Pf6iLG1H38=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [
    libpcap
  ];

  modRoot = "./v2";

  subPackages = [
    "cmd/naabu/"
  ];

  meta = with lib; {
    description = "Fast SYN/CONNECT port scanner";
    longDescription = ''
      Naabu is a port scanning tool written in Go that allows you to enumerate
      valid ports for hosts in a fast and reliable manner. It is a really simple
      tool that does fast SYN/CONNECT scans on the host/list of hosts and lists
      all ports that return a reply.
    '';
    homepage = "https://github.com/projectdiscovery/naabu";
    changelog = "https://github.com/projectdiscovery/naabu/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
