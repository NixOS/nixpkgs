{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "xcp";
  version = "0.20.4";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0ucm8XBxYwXvpVJN8If8BIToQGiBisKLZJYKuvaORto=";
  };

  # no such file or directory errors
  doCheck = false;

  cargoHash = "sha256-UdQUrIRos3TmebotdESvKH+90WVMJ0oTc43p+AT4xMI=";

  meta = with lib; {
    description = "An extended cp(1)";
    homepage = "https://github.com/tarka/xcp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lom ];
    mainProgram = "xcp";
  };
}
