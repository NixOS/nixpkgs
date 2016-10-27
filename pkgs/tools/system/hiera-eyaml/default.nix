{ lib, bundlerEnv, ruby }:

bundlerEnv {
  inherit ruby;
  pname = "hiera-eyaml";
  gemdir = ./.;

  meta = with lib; {
    description = "Per-value asymmetric encryption of sensitive data for Hiera";
    homepage = https://github.com/TomPoulton/hiera-eyaml;
    license = licenses.mit;
    maintainers = [ maintainers.benley ];
    platforms = platforms.unix;
  };
}
