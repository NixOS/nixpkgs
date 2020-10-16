{ wordpress }:

wordpress.overrideAttrs (oldAttrs: {
  pname = "wordpress-core";

  installPhase = oldAttrs.installPhase + ''
    rm -r $out/share/wordpress/wp-content/plugins/*
    rm -r $out/share/wordpress/wp-content/themes/*
  '';
})
