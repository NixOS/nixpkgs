{ stdenv, consul, ruby, bundlerEnv, zip, nodejs }:

let
  # `sass` et al
  gems = bundlerEnv {
    name = "consul-ui-deps";
    gemdir = ./.;
  };
in

stdenv.mkDerivation {
  name = "consul-ui-${consul.version}";

  src = consul.src;

  buildInputs = [ ruby gems zip nodejs ];

  patches = [ ./ui-no-bundle-exec.patch ];

  postPatch = "patchShebangs ./ui/scripts/dist.sh";

  buildPhase = ''
    # Build ui static files
    cd ui
    make dist
  '';

  installPhase = ''
    # Install ui static files
    mkdir -p $out
    mv ../pkg/web_ui/* $out
  '';

  meta = with stdenv.lib; {
    homepage    = https://www.consul.io/;
    description = "A tool for service discovery, monitoring and configuration";
    maintainers = with maintainers; [ cstrahan wkennington ];
    license     = licenses.mpl20 ;
    platforms   = platforms.unix;
  };
}
