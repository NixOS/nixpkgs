{ lib, stdenv, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  owner = "kurtbuilds";
  pname = "checkexec";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = owner;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-osLtyVXR4rASwRJmbu6jD8o3h12l/Ty4O8/XTl5UzB4=";
  };

  cargoHash = "sha256-ivNhvd+Diq54tmJfveJoW8F/YN294/zRCbsQPwpufak=";

  nativeBuildInputs = [ installShellFiles ];

  meta = with lib; {
    description =
      "checkexec is a tool to conditionally execute commands only when files in a dependency list have been updated";
    homepage = "https://github.com/kurtbuilds/checkexec";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.jceb ];
  };
}
