{ lib, bundlerEnv, ruby, bundlerUpdateScript, defaultGemConfig, fetchpatch }:

bundlerEnv {
  inherit ruby;

  pname = "fluentd";
  gemdir = ./.;

  gemConfig = defaultGemConfig // {
    fluentd = attrs: {
      dontBuild = false;
      patches = [
        (fetchpatch {
          name = "CVE-2022-39379.patch";
          url = "https://github.com/fluent/fluentd/commit/48e5b85dab1b6d4c273090d538fc11b3f2fd8135.patch";
          hash = "sha256-BNREUXe8EQ1rsJSXUFVGyuDyC6XX2uEDTke+WarK/Vg=";
        })
      ];
    };
  };

  passthru.updateScript = bundlerUpdateScript "fluentd";

  meta = with lib; {
    description = "A data collector";
    homepage    = "https://www.fluentd.org/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ offline nicknovitski ];
    platforms   = platforms.unix;
  };
}
