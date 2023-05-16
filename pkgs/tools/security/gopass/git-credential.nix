{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, gopass
}:

buildGoModule rec {
  pname = "git-credential-gopass";
<<<<<<< HEAD
  version = "1.15.7";
=======
  version = "1.15.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "git-credential-gopass";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-O8lqrvaFfcFHevZpRf+VbIQCBQUuc+B34OmQ3/VIOzI=";
  };

  vendorHash = "sha256-gb9AZBh5oUAiuCXbsvkmYxcHRNd9KLYq35nMd4iabKw=";
=======
    hash = "sha256-jjW+mqGklnQsX+nznEeehrIMoJ3MX1H5aF7LAePY2g0=";
  };

  vendorHash = "sha256-BXzXpG1Dy25IBf8EzgzOnFcbEvQGVhO8jgR/t6IKgPw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s" "-w" "-X main.version=${version}" "-X main.commit=${src.rev}"
  ];

  postFixup = ''
    wrapProgram $out/bin/git-credential-gopass \
      --prefix PATH : "${lib.makeBinPath [ gopass ]}"
  '';

  meta = with lib; {
    description = "Manage git credentials using gopass";
    homepage = "https://github.com/gopasspw/git-credential-gopass";
<<<<<<< HEAD
    changelog = "https://github.com/gopasspw/git-credential-gopass/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ benneti ];
  };
}
