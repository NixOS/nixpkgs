{ lib, stdenvNoCC, fetchgit, git, curl, jq, nix-prefetch, runtimeShell }:

stdenvNoCC.mkDerivation {
  name = "ble.sh";
  version = "0.3.3";

  src = fetchgit {
    url = "https://github.com/akinomyoga/ble.sh.git";
    rev = "refs/tags/v0.3.3";
    hash = "sha256-Gfo2S1t5Kdy+8TEDS4M5yhyRShvzQIljdE0MQK1CL+4=";
    fetchSubmodules = true;
    leaveDotGit = true;
  };

  nativeBuildInputs = [ git ];
  buildInputs = [ curl jq nix-prefetch ];

  doCheck = true;

  installFlags = [ "INSDIR=$(out)/share" ];
  postInstall = ''
    mkdir -p "$out/bin"
    cat <<SCRIPT >"$out/bin/ble.sh-share"
    #!${runtimeShell}
    # Run this script to find the ble.sh shared folder
    # where all the shell scripts are living.
    echo "$out/share/ble.sh"
    SCRIPT
    chmod +x "$out/bin/ble.sh-share"

    mkdir -p "$out/share/lib"
    cat <<SCRIPT >"$out/share/lib/_package.sh"
    _ble_base_package_type=nix

    function ble/base/package:nix/update {
      local rev=\$(${curl}/bin/curl -sL 'https://api.github.com/repos/akinomyoga/ble.sh/branches/master' | ${jq}/bin/jq -r '.commit.sha')
      local hash="\$(${nix-prefetch}/bin/nix-prefetch fetchgit --url 'https://github.com/akinomyoga/ble.sh.git' --branchName master --rev \$rev --leaveDotGit --fetchSubmodules 2>/dev/null)"

      cat <<-EOS >/dev/stderr
    	You cannot update ble.sh automatically via Nix.
    	The latest ble.sh from master branch can be installed by overriding nixpkgs like following.

    	  pkgs.ble-sh.overrideAttrs (_: {
    	    src = pkgs.fetchgit {
    	      url = "https://github.com/akinomyoga/ble.sh.git";
    	      rev = "\$rev";
    	      hash = "\$hash";
    	      fetchSubmodules = true;
    	      leaveDotGit = true;
    	    };
    	    doCheck = false;
    	  });
    	EOS
      return 1
    }
    SCRIPT
  '';

  meta = with lib; {
    homepage = "https://github.com/akinomyoga/ble.sh";
    description = "Bash Line Editor -- a full-featured line editor written in pure Bash";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aiotter ];
    platforms = platforms.unix;
  };
}
