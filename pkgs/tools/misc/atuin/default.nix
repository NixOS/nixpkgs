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
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "ellie";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TrIBNvK8Kyp0FgLZ3Q1n/Dl4V/yateP2v2ei5IIpi44=";
  };

  cargoSha256 = "sha256-42eMvUbH7eEvTcEfLtDRNy6psbdQXDsZQbpyqZFjF4c=";

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
