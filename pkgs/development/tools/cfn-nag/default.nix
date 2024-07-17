{
  lib,
  bundlerEnv,
  bundlerUpdateScript,
  ruby,
}:

bundlerEnv {
  pname = "cfn-nag";
  version = "0.8.9";

  inherit ruby;
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "cfn-nag";

  meta = with lib; {
    description = "Linting tool for CloudFormation templates";
    homepage = "https://github.com/stelligent/cfn_nag";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
