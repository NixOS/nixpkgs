{ stdenv, fetchFromGitHub, buildGoPackage, bash, writeText}:

buildGoPackage rec {
  name = "direnv-${version}";
  version = "2.12.2";
  goPackagePath = "github.com/direnv/direnv";

  src = fetchFromGitHub {
    owner = "direnv";
    repo = "direnv";
    rev = "v${version}";
    sha256 = "0i8fnxhcl1zin714wxk93x8fi36z4fibapfn4jl3qkwbczkj8c8b";
  };

  postConfigure = ''
    cd $NIX_BUILD_TOP/go/src/$goPackagePath
  '';

  buildPhase = ''
    make BASH_PATH=${bash}/bin/bash
  '';

  installPhase = ''
    mkdir -p $out
    make install DESTDIR=$bin
    mkdir -p $bin/share/fish/vendor_conf.d
    echo "eval ($bin/bin/direnv hook fish)" > $bin/share/fish/vendor_conf.d/direnv.fish
  '' + stdenv.lib.optionalString (stdenv.isDarwin) ''
    install_name_tool -delete_rpath $out/lib $bin/bin/direnv
  '';

  meta = with stdenv.lib; {
    description = "A shell extension that manages your environment";
    longDescription = ''
      Once hooked into your shell direnv is looking for an .envrc file in your
      current directory before every prompt.

      If found it will load the exported environment variables from that bash
      script into your current environment, and unload them if the .envrc is
      not reachable from the current path anymore.

      In short, this little tool allows you to have project-specific
      environment variables.
    '';
    homepage = http://direnv.net;
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
