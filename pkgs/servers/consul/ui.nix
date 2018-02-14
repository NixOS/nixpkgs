{ stdenv, consul, ruby, bundlerEnv, zip }:

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

  buildInputs = [ ruby gems zip ];

  patchPhase = ''
    patchShebangs ./ui/scripts/dist.sh
  '' +
  # Patch out upstream's habit of checking if all deps are available,
  # hiding all error messages and installing them with `bundle install`
  # if they aren't.
  # That way we can easily see when upstream's deps changed but
  # `bundix` wasn't run to reflect that in nixpkgs.
  # This will have to be updated if
  # https://github.com/hashicorp/consul/pull/4176 is merged
  # (we still want to patch `bundle install` out to make the error
  # message more obvious).
  ''
    sed -i 's:bundle check >/dev/null 2>&1 || bundle install:bundle check:g' ui/scripts/dist.sh
  '';

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
