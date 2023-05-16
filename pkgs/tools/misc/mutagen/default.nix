<<<<<<< HEAD
{ lib, buildGoModule, fetchFromGitHub, fetchzip }:

buildGoModule rec {
  pname = "mutagen";
  version = "0.17.1";
=======
{ stdenv, lib, buildGoModule, fetchFromGitHub, fetchzip }:

buildGoModule rec {
  pname = "mutagen";
  version = "0.17.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mutagen-io";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-M7h8qlqqGK4Nl4yXL7ZhGTq/CL+LdDpI/nv90koyu3Y=";
  };

  vendorHash = "sha256-kfzT+230KY2TJVc0qKMi4TysmltZSgF/OvL5nPLPcbM=";
=======
    sha256 = "sha256-Dfs7hgyTjl3jU28YSd1XEe0wNKQxKgLLMKcrKSEvc4w=";
  };

  vendorSha256 = "sha256-kfzT+230KY2TJVc0qKMi4TysmltZSgF/OvL5nPLPcbM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  agents = fetchzip {
    name = "mutagen-agents-${version}";
    # The package architecture does not matter since all packages contain identical mutagen-agents.tar.gz.
    url = "https://github.com/mutagen-io/mutagen/releases/download/v${version}/mutagen_linux_amd64_v${version}.tar.gz";
    stripRoot = false;
    postFetch = ''
      rm $out/mutagen # Keep only mutagen-agents.tar.gz.
    '';
<<<<<<< HEAD
    hash = "sha256-RFB1/gzLjs9w8mebEd4M9Ldv3BrLIj2RsN/QAIJi45E=";
=======
    sha256 = "sha256-kQdlwNsZd/YrH5XagtQRA/1WFhw4fLmqQW+kZ4ykxfc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  doCheck = false;

  subPackages = [ "cmd/mutagen" "cmd/mutagen-agent" ];

<<<<<<< HEAD
  tags = [ "mutagencli" "mutagenagent" ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postInstall = ''
    install -d $out/libexec
    ln -s ${agents}/mutagen-agents.tar.gz $out/libexec/
  '';

  meta = with lib; {
    description = "Make remote development work with your local tools";
    homepage = "https://mutagen.io/";
    changelog = "https://github.com/mutagen-io/mutagen/releases/tag/v${version}";
    maintainers = [ maintainers.marsam ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
  };
}
