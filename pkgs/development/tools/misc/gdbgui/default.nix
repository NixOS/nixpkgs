{ stdenv, python27Packages, gdb, pkgs }:
let
  deps = import ./requirements.nix { inherit pkgs; };
in
python27Packages.buildPythonApplication rec {
    name = "${pname}-${version}";
    pname = "gdbgui";
    version = "0.10.1.0";

    buildInputs = [ gdb ];
    propagatedBuildInputs = builtins.attrValues deps.packages;

    src = python27Packages.fetchPypi {
      inherit pname version;
      sha256 = "1585vjbrc8r0a7069aism66c0kkj91yklpdblb9c34570zbpabvs";
    };

    postPatch = ''
      echo ${version} > gdbgui/VERSION.txt
    '';

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
