{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, rustPlatform
, libiconv
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "atuin";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "ellie";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tBOJkAQCL2YGEJ3gJPxBC0swMuwOQENnhLXyms8WW6g";
  };

  cargoSha256 = "sha256-P4jcJ6pl3ZGjiwNYfEjEiNVnE6mTDRUGl6gZW65Jn0I";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security SystemConfiguration ];

  outputs = [ "out" ] ++ (map (sh: "interactiveShellInit_${sh}") shells);
  shells = [ "bash" "zsh" "fish" ];
  postInstall = ''
    installShellCompletion --cmd atuin \
      ${lib.concatMapStrings (sh: " --${sh} <$($out/bin/autin gen-completions -s ${sh})")}
  '' + lib.concatMapStrings
    (sh: "$out/bin/atuin init ${sh} > $interactiveShellInit_${sh};")
    shells;

  meta = with lib; {
    description = "Replacement for a shell history which records additional commands context with optional encrypted synchronization between machines";
    homepage = "https://github.com/ellie/atuin";
    license = licenses.mit;
    maintainers = with maintainers; [ onsails SuperSandro2000 sciencentistguy ];
  };
}
