{ stdenv, python27Packages, gdb, pkgs }:
let
  deps = import ./requirements.nix { inherit pkgs; };
in
python27Packages.buildPythonApplication rec {
    name = "${pname}-${version}";
    pname = "gdbgui";
    version = "0.9.0.1";

    buildInputs = [ gdb ];
    propagatedBuildInputs = builtins.attrValues deps.packages;

    src = python27Packages.fetchPypi {
      inherit pname version;
      sha256 = "1gjc7dycrc4zafhrd9yib7qnh4agh7cpa6rlw4p5405rlmwmsbj3";
    };

    postInstall = ''
      wrapProgram $out/bin/gdbgui \
                  --prefix PATH : ${stdenv.lib.makeBinPath [ gdb ]}
    '';

    # make /etc/protocols accessible to fix socket.getprotobyname('tcp') in sandbox
    preCheck = stdenv.lib.optionalString stdenv.isLinux ''
      export NIX_REDIRECTS=/etc/protocols=${pkgs.iana-etc}/etc/protocols \
             LD_PRELOAD=${pkgs.libredirect}/lib/libredirect.so
    '';

    postCheck = stdenv.lib.optionalString stdenv.isLinux ''
      unset NIX_REDIRECTS LD_PRELOAD
    '';

    meta = with stdenv.lib; {
      description = "A browser-based frontend for GDB";
      license = licenses.gpl3;
      platforms = platforms.unix;
      maintainers = with maintainers; [ yrashk ];
    };

  }
