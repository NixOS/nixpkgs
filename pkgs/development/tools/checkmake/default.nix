{ buildGoPackage, fetchFromGitHub, git, pandoc, lib }:

buildGoPackage rec {
  pname = "checkmake";
  version = "0.1.0-2020.11.30";

  goPackagePath = "github.com/mrtazz/checkmake";

  src = fetchFromGitHub {
    owner = "mrtazz";
    repo = pname;
    rev = "575315c9924da41534a9d0ce91c3f0d19bb53ffc";
    sha256 = "121rsl9mh3wwadgf8ggi2xnb050pak6ma68b2sw5j8clmxbrqli3";
  };

  nativeBuildInputs = [ pandoc ];

  preBuild =
    let
      buildVars = {
        version = version;
        buildTime = "N/A";
        builder = "nix";
        goversion = "$(go version | egrep -o 'go[0-9]+[.][^ ]*')";
      };
      buildVarsFlags = lib.concatStringsSep " " (lib.mapAttrsToList (k: v: "-X main.${k}=${v}") buildVars);
    in
    ''
      buildFlagsArray+=("-ldflags=${buildVarsFlags}")
    '';

  postInstall = ''
    pandoc -s -t man -o checkmake.1 go/src/${goPackagePath}/man/man1/checkmake.1.md
    mkdir -p $out/share/man/man1
    mv checkmake.1 $out/share/man/man1/checkmake.1
  '';

  meta = with lib; {
    description = "Experimental tool for linting and checking Makefiles";
    homepage = "https://github.com/mrtazz/checkmake";
    license = licenses.mit;
    maintainers = with maintainers; [ vidbina ];
    platforms = platforms.linux;
    longDescription = ''
      checkmake is an experimental tool for linting and checking
      Makefiles. It may not do what you want it to.
    '';
  };
}
